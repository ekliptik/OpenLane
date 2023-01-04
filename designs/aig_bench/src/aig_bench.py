from amaranth.cli import main_parser, main_runner
from amaranth import *
import random
import argparse

random.seed('CTU in Prague')


class Stage(Elaboratable):
    def __init__(self, width):
        self.i = Signal(width)
        self.o = Signal(width)
        self.width = width

    def elaborate(self, _):
        m = Module()
        width = self.width
        for o_idx in range(width):
            sigs = []
            for sig_idx in range(2 * width):
                sigs.append(Signal(name="a"))
            for sig_idx in range(width - 1):
                invert_left = (random.randrange(0, 2) == 1)
                invert_right = (random.randrange(0, 2) == 1)
                left = invert_left ^ sigs[sig_idx * 2 + 1]
                right = invert_right ^ sigs[sig_idx * 2 + 2]
                m.d.comb += sigs[sig_idx].eq(left & right)
            for sig_idx in range(width):
                m.d.sync += sigs[sig_idx + width - 1].eq(self.i[sig_idx])
            m.d.comb += self.o[o_idx].eq(sigs[0])
        return m


class Top(Elaboratable):
    def __init__(self, width, depth):
        self.i = Signal(width)
        self.o = Signal(width)
        self.width = width
        self.depth = depth

    def elaborate(self, _):
        m = Module()
        stages = []

        for i in range(self.depth):
            stages.append(Stage(self.width))
            m.submodules += stages[i]
            if i > 0:
                m.d.comb += stages[i].i.eq(stages[i - 1].o)

        m.d.comb += stages[0].i.eq(self.i)
        m.d.comb += self.o.eq(stages[i].o)

        return m


parser = argparse.ArgumentParser()
parser.add_argument("-w", dest="width", type=int,
                    help="Pipeline stage I/O width")
parser.add_argument("-d", dest="depth", type=int,
                    help="Pipeline stage count")
parser = main_parser(parser=parser)
args = parser.parse_args()
a_top = Top(args.width, args.depth)
main_runner(parser, args, a_top, ports=[a_top.i, a_top.o])
