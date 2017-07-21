# Silent Circle Audit/Event Logging

## Introduction

Silent Circle tracks certain actions related to organizational
accounts and their users for the purposes of security analysis and
auditing.  These events are stored immutably by Silent Circle for a
limited time after the event occurs.  The events can be downloaded
using our API and may be ingested by a Security Information and Event
Management (SIEM) system.

In this document, we'll cover the data format used for events, the
different kinds of events we provide, and the API used for downloading
these events.

## Audit/event log format

Events are delivered as JSON-formatted blocks that include a unique ID
for each event, the type of the event, the date and time the event
occurred, whether the action corresponding to the event was successful
or whether it failed (e.g. due to invalid credentials), a
human-readable description of the event, the authenticated user who
generated the event, a list of users, devices, circles, or other
objects affected by the event, and other data that may be helpful for
understanding the event.

For example, here is an event corresponding to a successful login:

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

We'll cover each field, as these are common to all event types.

    "id": "945d0512-026d-4081-b7a8-8323820233b7"

The `id` of the event is a globally unique identifier for the event.
This identifier is helpful for referencing a particular event and for
deduplicating events from overlapping time series or from multiple
sources.  These identifiers are type 4 UUIDs as specified by RFC 4122.

    "timestamp": "2017-06-01T01:02:03.141592Z",

The `timestamp` is a datetime value that represents when the event
occurred.  Timestamps are always presented in Universal Coordinated
Time (UTC) rather than in a local timezone.  These timestamps are
formatted according to RFC 3339 / ISO 8601.

    "type": "user-login",

The `type` represents the type of the event.  Each kind of event has a
unique type.  The way that other fields are populated in the event
depends on the `type`.

    "result": "ok",

The `result` field indicates whether the action corresponding to the
event succeeded or failed.  If the event succeeded when we return
`"result": "ok"`.  If it failed then we return `"result": "fail"`.

    "description": "User login by SSO succeeded",

The `description` is a human-readable description of the event.

    "actors": [{"type": "user", "id": "john@example.com"}],

The `actors` field is a list of all authenticated users that
authorized the action to take place.  This field contains an empty set
when the action occurs without any authenticated users, such as with a
failed login.

The `targets` field is a list of all users, groups, circles, and other
objects that are within the domain of the organization and are
affected by the action.

The `data` field contains supplemental data useful for understanding
the action.  This field typically contains a list of type-annotated
objects.

For example, this represents a circle with a particular ID:

    "data": [
      {"type": "circle",
       "id": "a1370199-e22c-4a8c-8401-fc9d62d54f28"}]

As another example, this represents a particular list of settings and
the values for each:

    "data": [
      {"type": "org-settings",
       "values": {
         "notify_on_create_sso_user": true,
         "notify_on_add_device_to_user": true,
         "notify_on_remove_device_from_user": true}}]

## API for retrieving audit/event logs

To use the API, we need an API key.  Silent Circle provides this API
key in a secure out-of-band manner, such as by Silent Phone messaging
or via a PGP/GPG-encrypted email message to an authenticated public
key.  Your account's sales engineer coordinates getting you this key.

This API key must be protected from disclosure as it provides the
ability to authorize certain actions on your account.

Once we have our API key, we can make the needed REST-style HTTPS
request to receive a batch of logs.

### Making the API request

Here's an example request using the `curl` command-line utility:

    curl \
      -H"Accept: application/json;version=1" \
      -XGET \
      "https://api.silentcircle.com/sm/api/logs/?api_key=...&since=20170601T010203.141592Z&until=20170601T060203.141592Z&count=4242"

We'll cover each piece.  The endpoint for the request is:

    https://api.silentcircle.com/sm/api/logs/

This is the URL to which we want to send the request.

    GET

We use the `GET` HTTP method to make our request.

    Accept: application/json;version=1

We add an `Accept` header that indicates what kind of data format
we're willing to receive.  In this case, we'll be receiving
JSON-formatted data, and we want to use version 1 of the API, the
current version.

There are three URL parameters required by the API: the API key, the
time of the earliest events we want, and the time of the latest events
we want.

    api_key=...

In the `api_key` parameter, we'll include the full API key that we
received from Silent Circle.

    since=20170601T010203.141592Z
    after=20170601T010203.141592Z
    until=20170601T060203.141592Z
    before=20170601T060203.141592Z

The `since`, `after`, `until`, and `before` parameters constrain the
time of the logs received.

These datetime values can be formatted according to RFC 3339 and then
URL-encoded, or may be formatted without the `-` and `:` characters as
is permitted by ISO 8601.

At least one of `since` or `after` and at least one of `until` or
`before` must be provided.

The `since` parameter indicates the time of the earliest logs that we
want to receive.  This returns logs timestamped "greater than or equal
to" this time.

The `after` parameter indicates that we want to receive logs that
occur after the provided time.  This returns logs timestamped "greater
than" this time.

The `until` parameter indicates that we want to receive logs that
occur up to and including the provided time.  This returns logs
timestamped "less than or equal to" this time.

The `before` parameter indicates that we want to receive logs that
occur up but not including the provided time.  This returns logs
timestamped "less than" this time.

The `count` parameter indicates the number of log entries that we want
to receive in the response to this request.  If the number of logs
available is greater than the value provided for `count`, then we'll
return only `count` records.  The response will include the time of
the last log entry included so that you may use this time in a new
request using the `after` parameter to perform pagination.

### API request response

The response from the API is JSON-formatted data that includes a
version number, a unique transaction identifier in type 4 RFC 4122
UUID format, the times of the first and last log entries included in
the response, a count of the number of events returned, and a list of
all audit/event logs returned by the query.

The headers include a `Content-Type` of `application/json`.  For
example:

    ...
    Content-Type: application/json

    {
      version: 1,
      tid: "18e015ae-5e56-4d65-b719-ea0caa4f6eab",
      since: "2017-06-01T01:02:03.141592Z",
      until: "2017-06-01T06:02:03.141592Z",
      count: 4242,
      logs: [...]
    }

In the example, the section before the empty line contains the
headers.  Normal HTTP headers are provided along with the correct
`Content-Type`.

The section after the empty line represents the body.  This is
JSON-formatted data.

The `version` field matches the version we requested in our `Accept`
header unless that version is no longer supported, in which case we
may return the closest supported version.

The `tid` field is a unique transaction identifier which may be used
for troubleshooting.

The `since` field is a datetime that represents the timestamp of the
first and earliest event returned in the results.

The `until` field is a datetime that represents the timestamp of the
last and latest event returned in the results.

The `count` field is an integer representing the number of audit/event
log entries returned in the response.

The `logs` field contains a list of all logs returned by the query.

## Example audit/event logs

In this section, we'll describe each of the types of events that we
support.  For each, we'll provide an example of data that may be
returned.

### Failed login

The `user-login` event occurs whenever a login is attempted.  If the
login fails, `"result": "fail"` is set and no `actors` are set as no
user successfully authenticated.  The user whose account was
attempting to be accessed is provided in the `targets`.

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

On a successful login, the `user-login` event is provided with
`"result": "ok"` and with the user who logged in provided in the
`actors` as well as the `targets` as the authenticated user caused the
login.

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

When a user requests a password reset token, we provide the
`user-reset-password-token-request` event.  Note that this event does
not apply to SSO users.

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

When a user resets the password on the account using a password reset
token, we provide the `user-reset-password-by-token` event.  Note that
this event does not apply to SSO users.

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

When a user password is changed by an authenticated user, we provide
the `user-change-password` event.  If the user is changing his or her
own password, the user appears in both the `actors` and `targets`
fields.

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

When a user password is changed by an authenticated user, we provide
the `user-change-password` event.  If one user is changing the
password for another user, e.g. by using the Silent Manager, the user
who is changing the password appears in the `actors` field and the
user whose password is being changed appears in the `targets` field.

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

When a user's account is reset, clearing all devices and data, we
provide the `user-reset` event.

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

When a new user is created in your organization, we provide the
`user-create` event.  If the user was created by an administrative
user in your Silent Manager, the user who created the account appears
in the `actors`, and the user whose account was created appears in the
`targets`.

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

When a new user is created in your organization, we provide the
`user-create` event.  If the user was created automatically during a
first-time SSO login, the user who logged in appears in both the
`actors` and `targets` fields.

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

When a user is deleted from your organization, we provide the
`user-destroy` event.

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

When a user is set to be an administrative user in your Silent
Manager, we provide the `user-set-as-admin` event.

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

When a user is set to no longer be an administrative user in your
Silent Manager, we provide the `user-unset-as-admin` event.

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

When a user is promoted to be a manager of a group, we provide the
`user-set-as-group-manager` event.  The group to be managed appears in
the `targets`.

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

When a user is demoted from being a manager of a group, we provide the
`user-unset-as-group-manager` event.  The group no longer being
managed by this user appears in the `targets`.

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

When a user is added to a group, we provide the `user-add-to-group`
event.

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

When a user is removed from a group, we provide the
`user-remove-from-group` event.

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

When a plan is assigned to a user, we provide the `user-assign-plan`
event.  The plan assigned appears in the `targets`.

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

When a plan is removed from a user, we provide the
`user-unassign-plan` event.  The plan no longer assigned appears in
the `targets`.

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

When details about the user's account are changed, we provide the
`user-change-details` event.  The `data` field contains the new values
applied to the user.

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

When a user logs in on a new device, adding that device to his or her
account, we provide the `user-create-device` event.

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

When a device is deleted from a user, deauthorizing that instance of
Silent Phone on the device from further contact with our service and
causing Silent Phone on the device to wipe itself and return to the
login screen, we provide the `user-destroy-device` event.

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

### Organization disconnected from Global Circle using Circle-in-Circle

An administrator in the Silent Manager can remove your organization
from the Global Circle.  This prevents outside users and
organizations, except those whitelisted, from communicating with your
users.  When removing your organization from the Global Circle, we
provide the `cic-disconnect-global` event.

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-disconnect-global",
      "result": "ok",
      "description": "Organization disconnected from Global Circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": []
    }

### Organization connected with Global Circle using Circle-in-Circle

An administrator in the Silent Manager can connect your organization
with the Global Circle.  This allows all Silent Circle users and users
in other organizations to communicate with your users.  When
connecting your organization to the Global Circle, we provide the
`cic-connect-global` event.

    {
      "id": "945d0512-026d-4081-b7a8-8323820233b7",
      "timestamp": "2017-06-01T01:02:03.141592Z",
      "type": "cic-connect-global",
      "result": "ok",
      "description": "Organization connected to Global Circle",
      "actors": [{"type": "user", "id": "mary@example.com"}],
      "targets": [{"type": "circle", "id": "7249f60d-a015-4302-9fcd-1f3ba1fe6b2f"}],
      "data": []
    }

### Outside organization added to Circle-in-Circle whitelist

When an administrator in the Silent Manager adds a whitelist exception
allowing another organization to communicate with your users, we
provide the `cic-whitelist-add-circle` event.  The circle whitelisted
is provided in the `data` field.

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

When an administrator in the Silent Manager removes a whitelist
exception allowing another organization to communicate with your
users, we provide the `cic-whitelist-remove-circle` event.  The circle
no longer whitelisted is provided in the `data` field.

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

When an administrator in the Silent Manager adds a whitelist exception
allowing a user outside your organization to communicate with your
users, we provide the `cic-whitelist-add-user` event.  The user
whitelisted is provided in the `data` field.

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

When an administrator in the Silent Manager removes a whitelist
exemption allowing a user outside your organization to communicate
with your users, we provide the `cic-whitelist-remove-user` event.
The user no longer whitelisted is provided in the `data` field.

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

When an administrator in the Silent Manager changes top-level settings
that affect your organization, we provide the `org-change-settings`
event.  The new values of the settings changed are provided in the
`data` field.

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
