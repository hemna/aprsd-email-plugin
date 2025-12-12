
Aprsd Email plugin
==================


.. image:: https://img.shields.io/pypi/v/aprsd-email-plugin.svg
   :target: https://pypi.org/project/aprsd-email-plugin/
   :alt: PyPI


.. image:: https://img.shields.io/pypi/status/aprsd-email-plugin.svg
   :target: https://pypi.org/project/aprsd-email-plugin/
   :alt: Status


.. image:: https://img.shields.io/pypi/pyversions/aprsd-email-plugin
   :target: https://pypi.org/project/aprsd-email-plugin
   :alt: Python Version


.. image:: https://img.shields.io/pypi/l/aprsd-email-plugin
   :target: https://opensource.org/licenses/Apache%20Software%20License%202.0
   :alt: License



.. image:: https://img.shields.io/readthedocs/aprsd-email-plugin/latest.svg?label=Read%20the%20Docs
   :target: https://aprsd-email-plugin.readthedocs.io/
   :alt: Read the documentation at https://aprsd-email-plugin.readthedocs.io/


.. image:: https://github.com/hemna/aprsd-email-plugin/workflows/Tests/badge.svg
   :target: https://github.com/hemna/aprsd-email-plugin/actions?workflow=Tests
   :alt: Tests


.. image:: https://codecov.io/gh/hemna/aprsd-email-plugin/branch/main/graph/badge.svg
   :target: https://codecov.io/gh/hemna/aprsd-email-plugin
   :alt: Codecov



.. image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :target: https://github.com/pre-commit/pre-commit
   :alt: pre-commit


..

   [!WARNING]
   Legal operation of this software requires an amateur radio license and a valid call sign.

   [!NOTE]
   Star this repo to follow our progress! This code is under active development, and contributions are both welcomed and appreciated. See `CONTRIBUTING.md <https://github.com/craigerl/aprsd/blob/master/CONTRIBUTING.md>`_ for details.


Features
--------

The APRSD Email Plugin enables Ham radio operators to send and receive email over APRS! Key features include:


* **Send Email via Radio**\ : Send emails from your radio by sending APRS messages
* **Receive Email via Radio**\ : Automatically receive new emails as APRS messages
* **Email Shortcuts**\ : Use short aliases instead of full email addresses
* **Automatic Email Checking**\ : Background thread periodically checks for new emails
* **Resend Recent Emails**\ : Request recent emails to be resent via APRS
* **Smart Rate Limiting**\ : Prevents duplicate email sends within 5 minutes
* **IMAP/SMTP Support**\ : Works with any IMAP/SMTP server (Gmail, Outlook, etc.)

Requirements
------------


* ``aprsd >= 4.0.2``
* A running APRSD instance
* Access to an IMAP server for receiving email
* Access to an SMTP server for sending email

Installation
------------

You can install *APRSD Email Plugin* via `pip <https://pip.pypa.io/>`_ from `PyPI <https://pypi.org/>`_\ :

.. code-block:: console

   $ pip install aprsd-email-plugin

Or using ``uv``\ :

.. code-block:: console

   $ uv pip install aprsd-email-plugin

Configuration
-------------

Before using the email plugin, you need to configure it in your APRSD configuration file.
Generate a sample configuration file if you haven't already:

.. code-block:: console

   $ aprsd sample-config

This will create a configuration file at ``~/.config/aprsd/aprsd.conf`` (or ``aprsd.yml``\ ).

Email Plugin Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^

Add the following section to your APRSD configuration file to configure the email plugin:

.. code-block:: yaml

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

Gmail Configuration Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^

For Gmail, you'll need to use an `App Password <https://support.google.com/accounts/answer/185833>`_ instead of your regular password:

.. code-block:: yaml

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

Other Email Providers
^^^^^^^^^^^^^^^^^^^^^

**Outlook/Hotmail:**

.. code-block:: yaml

   imap_host = outlook.office365.com
   imap_port = 993
   smtp_host = smtp.office365.com
   smtp_port = 587
   smtp_use_ssl = False  # Use STARTTLS instead

**Yahoo:**

.. code-block:: yaml

   imap_host = imap.mail.yahoo.com
   imap_port = 993
   smtp_host = smtp.mail.yahoo.com
   smtp_port = 465

Usage
-----

Once installed and configured, the email plugin will automatically start when you run ``aprsd server``.

Sending Email (Radio to Email)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To send an email from your radio, send an APRS message to your callsign with the format:

.. code-block::

   -email@address.com Your message here

**Examples:**


* ``-user@example.com Hello from my radio!``
* ``-mom@gmail.com Running late, be home soon``
* If you have shortcuts configured: ``-wb Meeting at 2pm`` (sends to walt@example.com)

**Special Command - Send Location:**

.. code-block::

   -email@address.com mapme

This sends a link to your current location on aprs.fi.

Receiving Email (Email to Radio)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The plugin automatically checks your IMAP inbox for new emails and forwards them to your radio as APRS messages. The format is:

.. code-block::

   -sender@address.com Email body content here

The plugin:


* Checks for new emails periodically (starts at 60 seconds, increases to 300 seconds max)
* Only forwards emails that haven't been sent via APRS before (marked with "APRS" flag)
* Automatically increases check frequency when email activity occurs

Resending Recent Emails
^^^^^^^^^^^^^^^^^^^^^^^

To request the most recent emails to be resent:

.. code-block::

   -1  # Resend 1 most recent email
   -2  # Resend 2 most recent emails
   -3  # Resend 3 most recent emails

The plugin will resend emails received today, with an asterisk (*) indicating it's a resend.

Email Shortcuts
^^^^^^^^^^^^^^^

Email shortcuts allow you to use short aliases instead of full email addresses:

**Configuration:**

.. code-block:: yaml

   email_shortcuts = wb=walt@example.com,cl=cl@example.com,mom=mom@gmail.com

**Usage:**


* Send to shortcut: ``-wb Meeting at 2pm`` (sends to walt@example.com)
* Receive from shortcut: If you receive email from walt@example.com, it will show as ``-wb`` in the APRS message

Verifying It's Working
^^^^^^^^^^^^^^^^^^^^^^

After starting APRSD, check the logs for messages like:

.. code-block::

   INFO: Email shortcuts {'wb': 'walt@example.com', 'cl': 'cl@example.com'}
   INFO: Checking IMAP configuration
   INFO: Checking SMTP configuration

If configuration is valid, you'll see:

.. code-block::

   INFO: Email services enabled

To test sending email:


#. Send yourself an APRS message: ``-your-email@gmail.com Test message``
#. Check your email inbox for the message

To test receiving email:


#. Send an email to your configured email address
#. Wait up to 60 seconds (or trigger a check by sending an email command)
#. You should receive the email as an APRS message

Troubleshooting
^^^^^^^^^^^^^^^

**Plugin not enabled:**


* Check that ``enabled = True`` in your config
* Verify ``callsign`` is set correctly
* Check logs for configuration errors

**Cannot connect to IMAP/SMTP:**


* Verify host, port, and SSL settings are correct
* For Gmail, ensure you're using an App Password, not your regular password
* Check firewall settings
* Enable ``debug = True`` for detailed connection logs

**Emails not being received:**


* Check that emails are arriving in your inbox (not spam)
* Verify IMAP credentials are correct
* Check logs for IMAP connection errors
* Ensure the plugin has permission to access your inbox

**Duplicate emails:**


* The plugin prevents sending the same email within 5 minutes
* If you need to resend, wait 5 minutes or use the resend command (\ ``-1``\ , ``-2``\ , etc.)

For more details, see the `Command-line Reference <https://aprsd-email-plugin.readthedocs.io/en/latest/usage.html>`_.

Contributing
------------

Contributions are very welcome. To learn more, see the `Contributor
Guide <CONTRIBUTING.rst>`_.

License
-------

Distributed under the terms of the `Apache Software License 2.0
license <https://opensource.org/licenses/Apache%20Software%20License%202.0>`_\ ,
*Aprsd Email plugin* is free and open source software.

Issues
------

If you encounter any problems, please `file an
issue <https://github.com/hemna/aprsd-email-plugin/issues>`_ along with a
detailed description.

Credits
-------

This project was generated from `\@hemna <https://github.com/hemna>`_\ \'s
`APRSD Plugin Python
Cookiecutter <https://github.com/hemna/cookiecutter-aprsd-plugin>`_
template.
