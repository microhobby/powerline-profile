from powerline_shell.utils import BasicSegment
import os
import sys

# local imports
sys.path.insert(
    0,
    os.path.expanduser('~/projects/B/powerline-profile')
)

import colors


class Segment(BasicSegment):
    def add_to_powerline(self):
        # get the cwd
        # but only the two last parts
        cwd = os.getcwd()
        parts = cwd.split(os.sep)
        if len(parts) >= 2:
            display_cwd = os.sep.join(parts[-2:])
        else:
            display_cwd = cwd

        self.powerline.append(f" {display_cwd} ", colors.WHITE, colors.GREY23)
