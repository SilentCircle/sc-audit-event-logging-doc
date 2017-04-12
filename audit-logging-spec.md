# Specification for Event/Audit Logging

Logging of:

- SSO account creation via login

  - timestamp
  - alias
  - method

- Password reset token request

  - timestamp
  - alias
  - method

- Password reset request

  - timestamp
  - alias
  - method
  - errors

    - invalid_token

- Login redirection to SSO

  - timestamp
  - alias
  - method

- Password login

  - timestamp
  - alias
  - method
  - errors

    - invalid_password

- SSO login

  - timestamp
  - alias
  - method
  - errors

    - sso_rejected

- Reset account

  - timestamp
  - method
  - actor alias
  - users

- Users added

  - timestamp
  - method
  - actor alias
  - users

    - username
    - first_name
    - last_name
    - email
    - groups
    - plan
    - directory_listing_visibility

- Groups added

  - timestamp
  - method
  - actor alias
  - groups

    - name

- CiC whitelist organizations

  - timestamp
  - method
  - actor alias
  - organizations

    - circle_id

- CiC de-whitelist organizations

  - timestamp
  - method
  - actor alias
  - organizations

    - circle_id

- CiC whitelist users

  - timestamp
  - method
  - actor alias
  - users

    - user_alias

- CiC de-whitelist users

  - timestamp
  - method
  - actor alias
  - users

    - user_alias

-  Change setting

  - timestamp
  - method
  - actor alias
  - settings

    - key
    - old_value
    - new_value
