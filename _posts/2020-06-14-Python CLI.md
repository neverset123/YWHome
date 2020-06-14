---
layout:     post
title:      python CLI
subtitle:   
date:       2020-06-14
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

two modules are introduced here

## click
decorator for python functions

    import click
    @click.command() # offer print help function
    #adding arguments option
    @click.option("--in", "-i", "in_file", required=True,
        help="Path to csv file to be processed.",
        type=click.Path(exists=True, dir_okay=False, readable=True),
    )
     #output detail help information
    @click.option('--verbose', is_flag=True, help="Verbose output")
    # adding different server options
    @click.option(
        "--dev", "server_url", help="Upload to dev server",
        flag_value='https://dev.server.org/api/v2/upload',
    )
    #adding user and password prompt
    @click.option('--user', prompt=True,
              default=lambda: os.environ.get('USER', ''))
    @click.password_option()
## argparse
arguments for python script

    import argparse
    parser = argparse.ArgumentParser(description='Videos to images')
    parser.add_argument('indir', type=str, help='Input dir for videos')
    parser.add_argument('outdir', type=str, help='Output dir for image')
    parser.add_argument(
        '--my_optional',
        default=2,
        help='provide an integer (default: 2)')
    args = parser.parse_args()

