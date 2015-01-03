'use strict';
var config = require('raintank-core/config').cnf();

/*-------------------------------------------------------
*    Raintank Configuration File.
*
*--------------------------------------------------------*/
// remove objects from DB after 90days.
config.deleteTTL = 60*60*24*90;

config.adminToken = 'jk832sjksf9asdkvnngddfg8sfk';

config.mongoURL = 'mongodb://dbuser:dbpass@mongodb/raintank';

config.siteUrl = "http://proxy/";

config.defaultRole = '5314801a421408bcac0a6448';
config.primaryLocation = '5337ed35033bb9203cfc1849';

config.emailFrom = "alerts@raintank.io";

config.graphite_api = {
	host: 'graphite-api',
	port: 8888
}

config.carbon = {
	host: 'influxdb',
	port: 2003
}

config.numCPUs = 1;

config.elasticSearch = {
  host: 'elasticsearch:9200',
  log: 'info'
};

config.queue = {
  publisherSocketAddr: 'tcp://broker:9997',
  consumerSocketAddr: "tcp://broker:9998",
  partitions: 10,
  mgmtUrl: "http://broker:9999"
};

/*-------------------------------------------------------*/
function parseEnv(name, value, cnf) {
	if (name in cnf) {
		cnf[name] = value;
		return;
	}
	var parts = name.split('_');
	var pos = 0
	var found = false
	while (!found && pos < parts.length) {
		pos = pos + 1;
		var group = parts.slice(0,pos).join('_');
		if (group in cnf){
			found = true;
			parseEnv(parts.slice(pos).join('_'), value, cnf[group]);
		}
	}
	if (!found) {
		console.log("%s not found in config", name);
	}
}

// overwrite with Environment variables
for (var key in process.env) {
	if (key.indexOf('RAINTANK_') == 0) {
		var name = key.slice(9);
		parseEnv(name, process.env[key], config);
	}
}

exports.config = config;
