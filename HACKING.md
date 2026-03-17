Testing
=======

Testing interactively within Lisp
---------------------------------

- Run the Common Lisp tests with

        (asdf:test-system "mgl-pax")

    Or just load the `"mgl-pax-test"` system and do, for example:

        (mgl-pax-test:test :debug 'try:unexpected).

The tests do not fail if there are unexpected successes, but it's
expected not to expect them to be failures.

Testing from the command line
-----------------------------

The shell script `test/test.sh` runs the tests on several Lisp
implementations assuming that they are installed under Roswell (e.g.
`ros --lisp sbcl run` works). So install ABCL, CCL, CMUCL, CLISP, ECL,
and SBCL under Roswell:

    for lisp in abcl-bin ccl-bin clisp cmu-bin ecl sbcl; do
        ros install $lisp
    done

Debugging test failures can be easier if `--batch` is removed from
the script.
