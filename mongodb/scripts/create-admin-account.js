use admin
db.createUser(
  {
    user: "admin",
    pwd: "adminPass",
    roles:
    [
      {
        role: "userAdminAnyDatabase",
        db: "admin"
      }
    ]
  }
)
