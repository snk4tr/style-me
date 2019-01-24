import subprocess

from argparse import ArgumentParser

from style_me_backend.main import main as app_main


def run_tests():
    subprocess.check_call(["python", "-m", "unittest", "discover", "-s", "tests"])


def get_cli_arguments():
    parser = ArgumentParser()

    parser.add_argument("--skip_tests", action='store_true', default=False, help="Skip tests before actual code.")

    args = parser.parse_args()
    return args


def main():
    args = get_cli_arguments()

    if not args.skip_tests:
        run_tests()

    app_main()


if __name__ == '__main__':
    main()
