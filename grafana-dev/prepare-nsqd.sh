#!/bin/bash
curl -X POST 'http://nsqd:4151/topic/create?topic=metrics'
curl -X POST 'http://nsqd:4151/channel/create?topic=metrics&channel=kairos'
curl -X POST 'http://nsqd:4151/channel/create?topic=metrics&channel=elasticsearch'
