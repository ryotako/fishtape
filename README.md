<a name="fisherman"></a>
<br>
<br>
<p align=center><img width=400px src=https://cloud.githubusercontent.com/assets/8317250/12931559/c9691de6-cfc1-11e5-8957-9b75261d0d13.png></p>
<br>
<br>
[![Build Status][travis-badge]][travis-link]
[![Fishtape Version][version-badge]][version-link]
[![Wharf][wharf-badge]][wharf-link]


<hr>

**Fishtape** is a [TAP][tap] producer and test harness for [Fish][fish]. It scans one or more `.fish` files and evaluate _test blocks_ producing a TAP stream.

## Install

With [Fisherman][fisherman]:

```fish
fisher install fishtape
```

Manually:

```fish
git clone https://github.com/fishery/fishtape
cd fishtape
make install
```

## Usage

### Writing Tests

Test files are `.fish` files with one or more test blocks. A test block consists of an optional description and any test expression supported by `test(1)`.

```fish
test "current directory is home"
    $HOME = $DIRNAME
end

test "math still works"
    42 -eq (math 41 + 1)
end

test "test is a builtin"
    "test" = (builtin -n)
end

test "no odds are evens"
    1 3 5 7 != (
        for i in (seq $n)
            if test (math $i%2) = 0
                echo $i
            end
        end
        )
end
```

### Running Tests

Fishtape reads any given files, or the standard input if no files are given, and converts test blocks into valid Fish syntax which is then evaluated, producing a TAP stream.

```fish
fishtape path/to/tests/*.fish
```

![Fishtape][screencast]


## Setup and Teardown

Include a `setup` and `teardown` method in your test file with code that must be run before and after _every_ test.

  * `setup`

  Run before each test in the current file. Use setup to load fixtures and/or set up your environment.

    ```fish
    set path $DIRNAME/$TESTNAME

    function setup
        mkdir -p $path
    end
    ```

  * `teardown`

  Run after each test in the current file. Use `teardown` to clean up loaded resources, etc.

    ```fish
    function teardown
        rm -rf $path
    end
    ```

## Variables

The following variables are available inside a test file:

  * `$FILENAME`:

      Path to the running script.

  * `$DIRNAME`:

      Directory name of the running script.

  * `$TEST`:

      Name of the running script.

  * `$TAP_VERSION`:

      TAP protocol version.

## Bugs

### Line Buffered Output

According to [fish-shell/#1396][fish-shell-1396], redirections and pipes involving blocks are run serially, not in parallel. This causes `fishtape` to block the pipeline and buffer all of its output. To emit a line buffered stream use `--pipe`=*program*.

For example:

```fish
fishtape test.fish --pipe=tap-nyan
```

### Tests

* Only one expression per test block is allowed. Use command substitutions to create arbitrarily complex test expressions.

* Each test file is wrapped within `begin; end` blocks behind the scenes to protect your local scope. In addition, global and universal variables are restored to their initial value before each test.

## Documentation

If you installed Fishtape using the manual procedure, you need to install the documentation separately.

```fish
cd fishtape
make doc
```

See [`fishtape(1)`][fishtape-1] for command usage help and [`fishtape(7)`][fishtape-7] for a quick introduction. For questions or feedback join the Slack [room][wharf-link] or browse the [issues][issues].

## See Also

* [Awesome TAP][awesome-tap] for a list of consumers / reporters, tools and other TAP resources.

<!-- Header -->

[travis-link]:      https://travis-ci.org/fishery/fishtape
[travis-badge]:     https://img.shields.io/travis/fishery/fishtape.svg?style=flat-square

[version-badge]:    https://img.shields.io/badge/latest-v1.4.0-00B9FF.svg?style=flat-square
[version-link]:     https://github.com/fisherman/fisherman/releases

[wharf-link]:       https://fisherman-wharf.herokuapp.com/
[wharf-badge]:  https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square

<!-- About -->

[tap]:          http://testanything.org/
[fish]:         http://fishshell.com/
[screencast]:   https://cloud.githubusercontent.com/assets/8317250/12836355/6ac01bd8-cbfb-11e5-8ea1-68a4b18e3a81.gif
[awesome-tap]:  https://github.com/sindresorhus/awesome-tap

<!-- Install -->

[fisherman]:    http://github.com/fisherman/fisherman

<!-- Documentation -->

[issues]:       https://github.com/fishery/fishtape/issues
[fishtape-1]:   man/man1/fishtape.md
[fishtape-7]:   man/man7/fishtape.md

<!-- Bugs -->

[fish-shell-1396]: https://github.com/fish-shell/fish-shell/issues/1396
