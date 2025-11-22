from powerline_shell.utils import BasicSegment
import psutil
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

        for proc in psutil.process_iter():
            try:
                if proc.cpu_percent() > 20:
                    self.powerline.append(
                        f" {proc.name()} ",
                        colors.BLACK,
                        colors.RED
                    )
            except:
                return

        return
