#!/usr/bin/env python
# coding:utf-8

__author__ = 'Youqi Wang'
__email__ = 'wangyouqi@yongche.com'
__date__ = '2015/07/07'


import os
import sys
import subprocess

try:
    import pexpect
    import argparse
except ImportError as e:
    print "Failed to import module: {0}".format(e)
    sys.exit(1)

def run_cmd(cmd):
    p = subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
    output, err = p.communicate()

    return (output, err, p.returncode)

def signpkg(pkg):
    if not os.path.exists(pkg):
        print "Can't find package to push. {0}: No such file or directory".format(pkg)
        sys.exit(1)

    p = pexpect.spawn("rpm --addsign {0}".format(pkg))
    p.expect("Enter.*")
    p.sendline("helloyongche")

    rtv = p.before

    p.expect(pexpect.EOF)


def pushpkg(branch, pkg):
    if branch not in ['stable', 'test']:
        print "Please specify the correct branch name, stable or test"
        sys.exit(1)

    if not os.path.exists(pkg):
        print "Can't find package to push. {0}: No such file or directory".format(pkg)
        sys.exit(1)

    output, err, rtv = run_cmd("yum dist-push --branch {0} --overwrite {1}".format(branch, pkg))

    if err:
       print err
       sys.exit(1)

    print output
    return True


if __name__ == '__main__':
    cmdparser = argparse.ArgumentParser()

    option_mg = cmdparser.add_mutually_exclusive_group()
    option_mg.add_argument('-sign', dest='sign_pkg')
    option_mg.add_argument('-push', dest='push_pkg')

    cmdparser.add_argument('-b', dest='branch')

    args = cmdparser.parse_args()

    if args.sign_pkg:
        signpkg(args.sign_pkg)

    if args.push_pkg:
        if args.branch:
            pushpkg(args.branch, args.push_pkg)
        else:
            print "Missing argument: -b branch"
            sys.exit(1)
