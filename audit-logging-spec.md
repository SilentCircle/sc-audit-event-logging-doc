# Specification for Audit/Event Logging

## Introduction

Silent Circle tracks certain actions related to organizational
accounts and their users for the purposes of security analysis and
auditing.

## Audit/event log format

## API usage

### Download audit/event logs

    curl \
      -H"Accept: application/json;version=1" \
      -XGET \
      "https://sccps.silentcircle.com/scmc/api/logs/?api_key=...&from=20170601T010203.141592Z&to=20170601T060203.141592Z"

    {
      logs: [...]
    }

## Example audit/event logs

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
      "type": "user-reset-password-token-request",
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
      "type": "user-reset-password-by-token",
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
      "type": "user-change-password",
      "result": "ok",
      "description": "User password changed by user",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### Password change by SM admin/manager

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-change-password",
      "result": "ok",
      "description": "User password changed by admin/manager",
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
      "data": []
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
      "data": []
    }

### User deleted

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-destroy",
      "result": "ok",
      "description": "User destroyed",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### User set as organizational admin

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-set-as-admin",
      "result": "ok",
      "description": "User has been set as an administrator",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### User removed as organizational admin

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-unset-as-admin",
      "result": "ok",
      "description": "User has been removed as an administrator",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": []
    }

### User set as group manager

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-set-as-group-manager",
      "result": "ok",
      "description": "User has been set as a group manager",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"},
                  {"type": "group", "name": "Sales"}],
      "data": []
    }

### User removed as group manager

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-unset-as-group-manager",
      "result": "ok",
      "description": "User has been set as a group manager",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"},
                  {"type": "group", "name": "Sales"}],
      "data": []
    }

### User added to group

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-add-to-group",
      "result": "ok",
      "description": "User has been added to group",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"},
                  {"type": "group", "name": "Sales"}],
      "data": []
    }

### User removed from group

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-remove-from-group",
      "result": "ok",
      "description": "User has been removed from group",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"},
                  {"type": "group", "name": "Sales"}],
      "data": []
    }

### Plan assigned to user

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-assign-plan",
      "result": "ok",
      "description": "Plan assigned to user",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com",
                   "type": "plan", "name": "SP w/o SW"}],
      "data": []
    }

### Plan removed from user

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-unassign-plan",
      "result": "ok",
      "description": "Plan unassigned from user",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com",
                   "type": "plan", "name": "SP w/o SW"}],
      "data": []
    }

### User details changed

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-change-details",
      "result": "ok",
      "description": "User details changed",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "user", "id": "john@example.com"}],
      "data": [
        {"type": "user-details",
         "values": {
           "first_name": "John",
           "last_name": "Smith",
           "email": "john@example.com"}}]
    }

### User logs in on new device

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-create-device",
      "result": "ok",
      "description": "User created new device",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [
        {"type": "user", "id": "john@example.com"},
        {"type": "device", "id": "9cd10d65a90f4ac1190f6ca40985e8a8"}],
      "data": []
    }

### User deletes device

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "user-destroy-device",
      "result": "ok",
      "description": "User deleted device",
      "actors": [{"type": "user", "id": "john@example.com"}],
      "targets": [
        {"type": "user", "id": "john@example.com"},
        {"type": "device", "id": "9cd10d65a90f4ac1190f6ca40985e8a8"}],
      "data": []
    }

### Outside organization added to Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-add-circle",
      "result": "ok",
      "description": "Circle-in-Circle whitelist added circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"type": "circle",
         "id": "a1370199-e22c-4a8c-8401-fc9d62d54f28"}]
    }

### Outside organization removed from Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-remove-circle",
      "result": "ok",
      "description": "Circle-in-Circle whitelist removed circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"type": "circle",
         "id": "a1370199-e22c-4a8c-8401-fc9d62d54f28"}]
    }

### Outside user added to Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-add-user",
      "result": "ok",
      "description": "Circle-in-Circle whitelist added user",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"type": "user",
         "id": "examplejohn"}]
    }

### Outside user removed from Circle-in-Circle whitelist

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-whitelist-remove-user",
      "result": "ok",
      "description": "Circle-in-Circle whitelist added user",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": [
        {"type": "user",
         "id": "examplejohn"}]
    }

### Organizational settings changed

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "org-change-settings",
      "result": "ok",
      "description": "Organizational settings changed",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [],
      "data": [
        {"type": "org-settings",
         "values": {
           "notify_on_create_sso_user": true,
           "notify_on_add_device_to_user": true,
           "notify_on_remove_device_from_user": true}}]
    }
