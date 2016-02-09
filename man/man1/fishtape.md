fishtape(1) -- TAP producer and test harness for Fish
=====================================================

## SYNOPSIS

`fishtape` [*file* ...]<br>
`fishtape` [`--time`=*utility*[,...]] [`--pipe`=*utility*]<br>
`fishtape` [`--help`] [`--version`]<br>


## DESCRIPTION

*Fishtape* is a TAP (Test Anything Protocol) producer and test harness for fish. It scans one or more `.fish` files and evaluate test blocks producing a TAP stream.


## OPTIONS

  * `-p`, `--pipe`=*utility*:
    Pipe line buffered output into the given *utility*.

  * `-v`, `--version`:
    Show version information.

  * `-h`, `--help`:
    Show help information.


## EXAMPLES

Test files are `.fish` files with one or more test blocks. A test block consists of an optional description and any test expression supported by `test`(1).

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

The general syntax is:

```fish
test description
    <expression>
end
```

Where *expression* is any `test`(1) valid expression; in addition, `=` and `!=` operators are overloaded to check for item inclusion or exclusion in lists.

```
test "this sentence contains the word it"
    it = this sentence contains the word it
end
```


## SETUP AND TEARDOWN

Include a `setup` and `teardown` method in your test file with code that must be run before and after _every_ test.

  * `setup`:
    Run before each test in the current file. Use `setup` to load fixtures and/or set up your environment.

    ```
    set path $DIRNAME/$TESTNAME

    function setup
        mkdir -p $path
    end
    ```

  * `teardown`:
    Run after each test in the current file. Use `teardown` to clean up loaded resources, etc.

    ```
    function teardown
        rm -rf $path
    end
    ```


## VARIABLES

The following variables are available inside a test file:

  * `$FILENAME`:
      Path to the running script.

  * `$DIRNAME`:
      Directory name of the running script.

  * `$TEST`:
      Name of the running script.

  * `$TAP_VERSION`:
      TAP protocol version.


## METHODS

The following methods are available inside a test file:

  * `comment` [*message*]:
      Print a message without breaking the tap output. This is a wrapper for `printf "# %s\n" >&2`.


## BUGS

### Line Buffered Output

According to <github.com/fish-shell/fish-shell/issues/1396> redirections and pipes involving blocks are run serially, not in parallel. This causes `fishtape` to block the pipeline and buffer all of its output. To emit a line buffered stream use `--pipe`=*program*.

    fishtape test.fish --pipe=tap-consumer

### Tests

* Only one expression per test block is allowed. Use command substitutions to create arbitrarily complex test expressions.

* Each test file is wrapped within `begin; end` blocks behind the scenes to protect your local scope. In addition, global and universal variables are restored to their initial value before each test.


## AUTHORS

Jorge Bucaran *j@bucaran.me*. See also AUTHORS.


## SEE ALSO

* `test`(1)
* `fishtape`(7)
* `help` expand-command-substitution
* `https://github.com/fisherman/fishtape/issues`

[fishtape-7]: https://github.com/bucaran/fishtape/blob/master/man/man7/fishtape.md
