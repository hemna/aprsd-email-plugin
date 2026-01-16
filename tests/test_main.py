import unittest
from unittest import mock

from aprsd_email_plugin import aprsd_email_plugin as email


class TestMain(unittest.TestCase):
    @mock.patch("aprsd_email_plugin.aprsd_email_plugin._imap_connect")
    @mock.patch("aprsd_email_plugin.aprsd_email_plugin._smtp_connect")
    def test_validate_email(self, imap_mock, smtp_mock):
        """Test to make sure we fail."""
        imap_mock.return_value = None
        smtp_mock.return_value = {"smaiof": "fire"}
        mock.MagicMock()

        email.validate_email_config(True)
