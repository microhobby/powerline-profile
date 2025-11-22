from powerline_shell.utils import BasicSegment
import sys
import os

# local imports
sys.path.insert(
    0,
    os.path.expanduser('~/projects/B/powerline-profile')
)

import colors


class Segment(BasicSegment):
    def add_to_powerline(self):
        self.powerline.append(
            f" {colors.Fg.color(52)}󰇷 ",
            colors.WHITE,
            colors.STEEL_BLUE1
        )
