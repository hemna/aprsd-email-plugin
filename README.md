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

-   This is a plugin for the `APRSD` python project that allows a Ham radio operator to send and recieve email over APRS!


### SEND EMAIL (radio to smtp server)

    Received message______________
    Raw         : KM6XXX>APY400,WIDE1-1,qAO,KM6XXX-1::KM6XXX-9 :-user@host.com test new shortcuts global, radio to pc{29
    From        : KM6XXX
    Message     : -user@host.com test new shortcuts global, radio to pc
    Msg number  : 29

    Sending Email_________________
    To          : user@host.com
    Subject     : KM6XXX
    Body        : test new shortcuts global, radio to pc

    Sending ack __________________ Tx(3)
    Raw         : KM6XXX-9>APRS::KM6XXX   :ack29
    To          : KM6XXX
    Ack number  : 29

### RECEIVE EMAIL (imap server to radio)

    Sending message_______________ 6(Tx3)
    Raw         : KM6XXX-9>APRS::KM6XXX   :-somebody@gmail.com email from internet to radio{6
    To          : KM6XXX
    Message     : -somebody@gmail.com email from internet to radio

    Received message______________
    Raw         : KM6XXX>APY400,WIDE1-1,qAO,KM6XXX-1::KM6XXX-9 :ack6
    From        : KM6XXX
    Message     : ack6
    Msg number  : 0


## Requirements

-   APRSD

## Installation

You can install *Aprsd Email plugin* via [pip](https://pip.pypa.io/)
from [PyPI](https://pypi.org/):

``` console
$ pip install aprsd-email-plugin
```

## Usage

Please see the [Command-line
Reference](https://aprsd-email-plugin.readthedocs.io/en/latest/usage.html)
for details.

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
