# Aprsd Email plugin

[![PyPI](https://img.shields.io/pypi/v/aprsd-email-plugin.svg)](https://pypi.org/project/aprsd-email-plugin/)
[![Status](https://img.shields.io/pypi/status/aprsd-email-plugin.svg)](https://pypi.org/project/aprsd-email-plugin/)
[![Python Version](https://img.shields.io/pypi/pyversions/aprsd-email-plugin)](https://pypi.org/project/aprsd-email-plugin)
[![License](https://img.shields.io/pypi/l/aprsd-email-plugin)](https://opensource.org/licenses/Apache%20Software%20License%202.0)

[![Read the documentation at https://aprsd-email-plugin.readthedocs.io/](https://img.shields.io/readthedocs/aprsd-email-plugin/latest.svg?label=Read%20the%20Docs)](https://aprsd-email-plugin.readthedocs.io/)
[![Tests](https://github.com/hemna/aprsd-email-plugin/workflows/Tests/badge.svg)](https://github.com/hemna/aprsd-email-plugin/actions?workflow=Tests)
[![Codecov](https://codecov.io/gh/hemna/aprsd-email-plugin/branch/main/graph/badge.svg)](https://codecov.io/gh/hemna/aprsd-email-plugin)

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

> [!WARNING]
> Legal operation of this software requires an amateur radio license and a valid call sign.

> [!NOTE]
> Star this repo to follow our progress! This code is under active development, and contributions are both welcomed and appreciated. See [CONTRIBUTING.md](<https://github.com/craigerl/aprsd/blob/master/CONTRIBUTING.md>) for details.

## Features

The APRSD Email Plugin enables Ham radio operators to send and receive email over APRS! Key features include:

-   **Send Email via Radio**: Send emails from your radio by sending APRS messages
-   **Receive Email via Radio**: Automatically receive new emails as APRS messages
-   **Email Shortcuts**: Use short aliases instead of full email addresses
-   **Automatic Email Checking**: Background thread periodically checks for new emails
-   **Resend Recent Emails**: Request recent emails to be resent via APRS
-   **Smart Rate Limiting**: Prevents duplicate email sends within 5 minutes
-   **IMAP/SMTP Support**: Works with any IMAP/SMTP server (Gmail, Outlook, etc.)

## Requirements

-   `aprsd >= 4.0.2`
-   A running APRSD instance
-   Access to an IMAP server for receiving email
-   Access to an SMTP server for sending email

## Installation

You can install *APRSD Email Plugin* via [pip](https://pip.pypa.io/) from [PyPI](https://pypi.org/):

``` console
$ pip install aprsd-email-plugin
```

Or using `uv`:

``` console
$ uv pip install aprsd-email-plugin
```

## Configuration

Before using the email plugin, you need to configure it in your APRSD configuration file.
Generate a sample configuration file if you haven't already:

``` console
$ aprsd sample-config
```

This will create a configuration file at `~/.config/aprsd/aprsd.conf` (or `aprsd.yml`).

### Email Plugin Configuration

Add the following section to your APRSD configuration file to configure the email plugin:

``` yaml
[aprsd_email_plugin]
# Enable the Email plugin (default: False)
enabled = True

# (Required) Callsign authorized to send/receive email commands
# This is also where email notifications for new emails will be sent
callsign = YOURCALL

# Enable debug logging for email operations (default: False)
debug = False

# IMAP Configuration (for receiving email)
imap_host = imap.gmail.com
imap_port = 993
imap_use_ssl = True
imap_login = your-email@gmail.com
imap_password = your-app-password

# SMTP Configuration (for sending email)
smtp_host = smtp.gmail.com
smtp_port = 465
smtp_use_ssl = True
smtp_login = your-email@gmail.com
smtp_password = your-app-password

# Email shortcuts (optional)
# Format: shortcut=email@address.com,shortcut2=email2@address.com
email_shortcuts = wb=walt@example.com,cl=cl@example.com
```

### Gmail Configuration Example

For Gmail, you'll need to use an [App Password](https://support.google.com/accounts/answer/185833) instead of your regular password:

``` yaml
[aprsd_email_plugin]
enabled = True
callsign = YOURCALL
debug = False

# Gmail IMAP settings
imap_host = imap.gmail.com
imap_port = 993
imap_use_ssl = True
imap_login = yourname@gmail.com
imap_password = your-16-char-app-password

# Gmail SMTP settings
smtp_host = smtp.gmail.com
smtp_port = 465
smtp_use_ssl = True
smtp_login = yourname@gmail.com
smtp_password = your-16-char-app-password

# Optional shortcuts
email_shortcuts = mom=mom@gmail.com,dad=dad@gmail.com
```

### Other Email Providers

**Outlook/Hotmail:**
``` yaml
imap_host = outlook.office365.com
imap_port = 993
smtp_host = smtp.office365.com
smtp_port = 587
smtp_use_ssl = False  # Use STARTTLS instead
```

**Yahoo:**
``` yaml
imap_host = imap.mail.yahoo.com
imap_port = 993
smtp_host = smtp.mail.yahoo.com
smtp_port = 465
```

## Usage

Once installed and configured, the email plugin will automatically start when you run `aprsd server`.

### Sending Email (Radio to Email)

To send an email from your radio, send an APRS message to your callsign with the format:

```
-email@address.com Your message here
```

**Examples:**
-   `-user@example.com Hello from my radio!`
-   `-mom@gmail.com Running late, be home soon`
-   If you have shortcuts configured: `-wb Meeting at 2pm` (sends to walt@example.com)

**Special Command - Send Location:**
```
-email@address.com mapme
```
This sends a link to your current location on aprs.fi.

### Receiving Email (Email to Radio)

The plugin automatically checks your IMAP inbox for new emails and forwards them to your radio as APRS messages. The format is:

```
-sender@address.com Email body content here
```

The plugin:
-   Checks for new emails periodically (starts at 60 seconds, increases to 300 seconds max)
-   Only forwards emails that haven't been sent via APRS before (marked with "APRS" flag)
-   Automatically increases check frequency when email activity occurs

### Resending Recent Emails

To request the most recent emails to be resent:

```
-1  # Resend 1 most recent email
-2  # Resend 2 most recent emails
-3  # Resend 3 most recent emails
```

The plugin will resend emails received today, with an asterisk (*) indicating it's a resend.

### Email Shortcuts

Email shortcuts allow you to use short aliases instead of full email addresses:

**Configuration:**
``` yaml
email_shortcuts = wb=walt@example.com,cl=cl@example.com,mom=mom@gmail.com
```

**Usage:**
-   Send to shortcut: `-wb Meeting at 2pm` (sends to walt@example.com)
-   Receive from shortcut: If you receive email from walt@example.com, it will show as `-wb` in the APRS message

## Example Interactions

Here are some real-world examples of how the email plugin works:

### Example 1: Sending an Email from Your Radio

**Scenario:** You're on a hike and want to let your family know you're doing well.

**On your radio:**
```
Send message to: YOURCALL
Message: -mom@gmail.com Having a great time on the trail! Weather is perfect.
```

**Result:** Your mom receives an email with:
- **Subject:** YOURCALL
- **Body:** Having a great time on the trail! Weather is perfect.

**On your radio (response):**
```
(No response message - email sent successfully)
```

### Example 2: Receiving an Email on Your Radio

**Scenario:** Someone sends you an email while you're out in the field.

**Email sent to your inbox:**
- **From:** friend@example.com
- **Subject:** Meeting reminder
- **Body:** Don't forget about the club meeting tonight at 7pm!

**On your radio (automatic, within 60 seconds):**
```
Message from: YOURCALL
Message: -friend@example.com Don't forget about the club meeting tonight at 7pm!
```

### Example 3: Using Email Shortcuts

**Configuration:**
``` yaml
email_shortcuts = mom=mom@gmail.com,dad=dad@gmail.com,wb=walt@example.com
```

**Sending with shortcut:**
```
Send message to: YOURCALL
Message: -wb Can you check the weather forecast?
```

**Result:** Email sent to walt@example.com

**Receiving with shortcut:**
If walt@example.com sends you an email, you'll see:
```
Message from: YOURCALL
Message: -wb The forecast looks good for tomorrow!
```

### Example 4: Sending Your Location

**Scenario:** You want to share your current location via email.

**On your radio:**
```
Send message to: YOURCALL
Message: -friend@example.com mapme
```

**Result:** Friend receives an email with:
- **Subject:** YOURCALL
- **Body:** Click for my location: http://aprs.fi/YOURCALL

### Example 5: Resending Recent Emails

**Scenario:** You missed some emails and want to see the last 2 that were sent.

**On your radio:**
```
Send message to: YOURCALL
Message: -2
```

**Result:** You receive the 2 most recent emails from today:
```
Message from: YOURCALL
Message: -friend@example.com * First email content here

Message from: YOURCALL
Message: -mom@gmail.com * Second email content here
```

Note: The asterisk (*) indicates these are resent emails.

### Example 6: Error Handling

**Scenario:** You try to send an email but the SMTP server is down.

**On your radio:**
```
Send message to: YOURCALL
Message: -user@example.com Test message
```

**On your radio (response):**
```
Message from: YOURCALL
Message: -user@example.com failed
```

**Scenario:** You use an invalid email address or shortcut.

**On your radio:**
```
Send message to: YOURCALL
Message: -invalid-address Hello
```

**On your radio (response):**
```
Message from: YOURCALL
Message: Bad email address
```

### Example 7: Rate Limiting

**Scenario:** You accidentally send the same message twice within 5 minutes.

**First attempt:**
```
Send message to: YOURCALL
Message: -mom@gmail.com Running late
```
**Result:** Email sent successfully

**Second attempt (within 5 minutes):**
```
Send message to: YOURCALL
Message: -mom@gmail.com Running late
```
**Result:** Email not sent (duplicate prevention active)
**On your radio:** (No response - message silently ignored)

**After 5 minutes:**
The same message can be sent again if needed.

### Example 8: Complete Conversation Flow

**Morning - You send an email:**
```
You (radio): -mom@gmail.com Heading out for the day, will check in later
```

**Afternoon - Mom replies via email:**
```
Email from mom@gmail.com: "Sounds good! Be safe!"
```

**You receive on radio (automatic):**
```
YOURCALL: -mom@gmail.com Sounds good! Be safe!
```

**Evening - You send location:**
```
You (radio): -mom@gmail.com mapme
```

**Mom receives email with link to your location on aprs.fi**

### Verifying It's Working

After starting APRSD, check the logs for messages like:

```
INFO: Email shortcuts {'wb': 'walt@example.com', 'cl': 'cl@example.com'}
INFO: Checking IMAP configuration
INFO: Checking SMTP configuration
```

If configuration is valid, you'll see:
```
INFO: Email services enabled
```

To test sending email:
1.  Send yourself an APRS message: `-your-email@gmail.com Test message`
2.  Check your email inbox for the message

To test receiving email:
1.  Send an email to your configured email address
2.  Wait up to 60 seconds (or trigger a check by sending an email command)
3.  You should receive the email as an APRS message

### Troubleshooting

**Plugin not enabled:**
-   Check that `enabled = True` in your config
-   Verify `callsign` is set correctly
-   Check logs for configuration errors

**Cannot connect to IMAP/SMTP:**
-   Verify host, port, and SSL settings are correct
-   For Gmail, ensure you're using an App Password, not your regular password
-   Check firewall settings
-   Enable `debug = True` for detailed connection logs

**Emails not being received:**
-   Check that emails are arriving in your inbox (not spam)
-   Verify IMAP credentials are correct
-   Check logs for IMAP connection errors
-   Ensure the plugin has permission to access your inbox

**Duplicate emails:**
-   The plugin prevents sending the same email within 5 minutes
-   If you need to resend, wait 5 minutes or use the resend command (`-1`, `-2`, etc.)

For more details, see the [Command-line Reference](https://aprsd-email-plugin.readthedocs.io/en/latest/usage.html).

## Contributing

Contributions are very welcome. To learn more, see the [Contributor
Guide](CONTRIBUTING.rst).

## License

Distributed under the terms of the [Apache Software License 2.0
license](https://opensource.org/licenses/Apache%20Software%20License%202.0),
*Aprsd Email plugin* is free and open source software.

## Issues

If you encounter any problems, please [file an
issue](https://github.com/hemna/aprsd-email-plugin/issues) along with a
detailed description.

## Credits

This project was generated from [\@hemna](https://github.com/hemna)\'s
[APRSD Plugin Python
Cookiecutter](https://github.com/hemna/cookiecutter-aprsd-plugin)
template.
