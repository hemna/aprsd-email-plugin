import unittest

from aprsd import conf  # noqa: F401
from oslo_config import cfg

from aprsd_email_plugin import aprsd_email_plugin as email

CONF = cfg.CONF


class TestEmail(unittest.TestCase):
    def test_get_email_from_shortcut(self):
        from unittest import mock

        email_address = "something@something.com"
        addr = f"-{email_address}"

        with (
            mock.patch.object(email, "shortcuts_dict", None),
            mock.patch.object(CONF.aprsd_email_plugin, "email_shortcuts", None),
        ):
            actual = email.get_email_from_shortcut(addr)
            self.assertEqual(addr, actual)

        with (
            mock.patch.object(email, "shortcuts_dict", None),
            mock.patch.object(
                CONF.aprsd_email_plugin,
                "email_shortcuts",
                ["wb=something@something.com"],
            ),
        ):
            actual = email.get_email_from_shortcut("wb")
            self.assertEqual(email_address, actual)
