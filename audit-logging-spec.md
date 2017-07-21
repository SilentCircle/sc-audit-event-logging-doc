# Specification for Event/Audit Logging

## Events

### Failed login

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-login",
      "result": "fail",
      "description": "User login by SSO failed due to expired token",
      "actors": [],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Successful login

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-login",
      "result": "ok",
      "description": "User login by SSO succeeded",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Password reset token request

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-password-reset-token-request",
      "result": "ok",
      "description": "User password reset token sent by email",
      "actors": [],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Password reset by token

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-password-reset-by-token",
      "result": "ok",
      "description": "User password reset using valid reset token",
      "actors": [],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Password change by user

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-password-change",
      "result": "ok",
      "description": "User password changed",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Password change by SM admin

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-password-change",
      "result": "ok",
      "description": "User password changed",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Account reset

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-reset",
      "result": "ok",
      "description": "User account reset",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### New user created by Silent Manager admin

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-create",
      "result": "ok",
      "description": "User created",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": [
        {"action": "create",
         "value": {
           "type": "user",
           "id": "john@example.com"}}]
    }

### New user created by SSO login

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-create",
      "result": "ok",
      "description": "User created by SSO login",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": [
        {"action": "create",
         "value": {
           "type": "user",
           "id": "john@example.com"}}]
    }

### Plan assigned to user

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-plan-change",
      "result": "ok",
      "description": "Plan assigned to user",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com",
                   "type": "plan", "name": "SP w/o SW"}],
      "data": [
        {"action": "add",
         "value": {
           "type": "plan",
           "name": "SP w/o SW"}}]
    }

### User details change

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-change",
      "result": "ok",
      "description": "User details changed",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": [
        {"action": "set",
         "key": "first-name",
         "value": "John"},
        {"action": "set",
         "key": "last-name",
         "value": "Smith"},
        {"action": "set",
         "key": "email",
         "value": "john@example.com"}]
    }

### User logs in on new device

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-device-list-change",
      "result": "ok",
      "description": "User created new device",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [
        {"type": "user", "id": "john@example.com"},
        {"type": "device", "id": "9cd10d65a90f4ac1190f6ca40985e8a8"}],
      "data": [
        {"action": "create",
         "value": {
           "type": "device",
           "id": "9cd10d65a90f4ac1190f6ca40985e8a8"}}]
    }

### User deletes device

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-device-list-change",
      "result": "ok",
      "description": "User deleted device",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [
        {"type": "user", "id": "john@example.com"},
        {"type": "device", "id": "9cd10d65a90f4ac1190f6ca40985e8a8"}],
      "data": [
        {"action": "destroy",
         "value": {
           "type": "device",
           "id": "9cd10d65a90f4ac1190f6ca40985e8a8"}}]
    }

### Outside organization added to Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-change",
      "result": "ok",
      "description": "Circle-in-Circle whitelist added circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"action": "add",
         "value": {
           "type": "circle",
           "id": "a1370199-e22c-4a8c-8401-fc9d62d54f28"}}]
    }

### Outside organization removed from Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-change",
      "result": "ok",
      "description": "Circle-in-Circle whitelist removed circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"action": "remove",
         "value": {
           "type": "circle",
           "id": "a1370199-e22c-4a8c-8401-fc9d62d54f28"}}]
    }

### Outside user added to Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-change",
      "result": "ok",
      "description": "Circle-in-Circle whitelist added circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"action": "add",
         "value": {
           "type": "user",
           "id": "john@example.com"}}]
    }

### Outside user removed from Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-change",
      "result": "ok",
      "description": "Circle-in-Circle whitelist added circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"action": "remove",
         "value": {
           "type": "user",
           "id": "john@example.com"}}]
    }

### Organizational settings changed

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "org-setting-change",
      "result": "ok",
      "description": "Organizational settings changed",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [],
      "data": [
        {"action": "set",
         "key": "notify-on-create-sso-user",
         "value": true},
        {"action": "set",
         "key": "notify-on-add-device-to-user",
         "value": true},
        {"action": "set",
         "key": "notify-on-remove-device-from-user",
         "value": true}]
    }
