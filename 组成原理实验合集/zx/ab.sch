<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="clk" />
        <signal name="rst" />
        <signal name="ce" />
        <signal name="c1" />
        <signal name="c2" />
        <signal name="c3" />
        <signal name="c4" />
        <signal name="c5" />
        <signal name="c6" />
        <signal name="c7" />
        <signal name="c8" />
        <signal name="c9" />
        <signal name="c10" />
        <signal name="XLXN_14" />
        <signal name="XLXN_15" />
        <signal name="XLXN_16" />
        <signal name="XLXN_17" />
        <signal name="XLXN_18" />
        <port polarity="Input" name="clk" />
        <port polarity="Input" name="rst" />
        <port polarity="Input" name="ce" />
        <port polarity="Output" name="c1" />
        <port polarity="Output" name="c2" />
        <port polarity="Output" name="c3" />
        <port polarity="Output" name="c4" />
        <port polarity="Output" name="c5" />
        <port polarity="Output" name="c6" />
        <port polarity="Output" name="c7" />
        <port polarity="Output" name="c8" />
        <port polarity="Output" name="c9" />
        <port polarity="Output" name="c10" />
        <blockdef name="myrom">
            <timestamp>2018-1-11T3:58:56</timestamp>
            <rect width="256" x="64" y="-640" height="640" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-320" y2="-320" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-608" y2="-608" x1="320" />
            <line x2="384" y1="-544" y2="-544" x1="320" />
            <line x2="384" y1="-480" y2="-480" x1="320" />
            <line x2="384" y1="-416" y2="-416" x1="320" />
            <line x2="384" y1="-352" y2="-352" x1="320" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="cb4ce">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <rect width="256" x="64" y="-512" height="448" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="320" y1="-320" y2="-320" x1="384" />
            <line x2="320" y1="-384" y2="-384" x1="384" />
            <line x2="320" y1="-448" y2="-448" x1="384" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="320" y1="-128" y2="-128" x1="384" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="320" y1="-192" y2="-192" x1="384" />
        </blockdef>
        <blockdef name="clock_divider">
            <timestamp>2013-3-22T2:41:24</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <block symbolname="myrom" name="XLXI_1">
            <blockpin signalname="XLXN_16" name="s0" />
            <blockpin signalname="XLXN_17" name="s1" />
            <blockpin signalname="XLXN_18" name="s2" />
            <blockpin signalname="c1" name="c1" />
            <blockpin signalname="c2" name="c2" />
            <blockpin signalname="c3" name="c3" />
            <blockpin signalname="c4" name="c4" />
            <blockpin signalname="c5" name="c5" />
            <blockpin signalname="c6" name="c6" />
            <blockpin signalname="c7" name="c7" />
            <blockpin signalname="c8" name="c8" />
            <blockpin signalname="c9" name="c9" />
            <blockpin signalname="c10" name="c10" />
        </block>
        <block symbolname="cb4ce" name="XLXI_2">
            <blockpin signalname="XLXN_14" name="C" />
            <blockpin signalname="ce" name="CE" />
            <blockpin signalname="rst" name="CLR" />
            <blockpin name="CEO" />
            <blockpin signalname="XLXN_16" name="Q0" />
            <blockpin signalname="XLXN_17" name="Q1" />
            <blockpin signalname="XLXN_18" name="Q2" />
            <blockpin name="Q3" />
            <blockpin name="TC" />
        </block>
        <block symbolname="clock_divider" name="XLXI_3">
            <blockpin signalname="clk" name="clk_in" />
            <blockpin signalname="rst" name="rst" />
            <blockpin signalname="XLXN_14" name="clk_1Hz" />
            <blockpin name="clk_5Hz" />
            <blockpin name="clk_10Hz" />
            <blockpin name="clk_1KHz" />
            <blockpin name="clk_1MHz" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="576" y="1632" name="XLXI_3" orien="R0">
        </instance>
        <instance x="1312" y="1184" name="XLXI_2" orien="R0" />
        <instance x="2160" y="1472" name="XLXI_1" orien="R0">
        </instance>
        <branch name="clk">
            <wire x2="576" y1="1344" y2="1344" x1="544" />
        </branch>
        <iomarker fontsize="28" x="544" y="1344" name="clk" orien="R180" />
        <branch name="rst">
            <wire x2="560" y1="1600" y2="1600" x1="448" />
            <wire x2="576" y1="1600" y2="1600" x1="560" />
            <wire x2="1312" y1="1152" y2="1152" x1="560" />
            <wire x2="560" y1="1152" y2="1600" x1="560" />
        </branch>
        <branch name="ce">
            <wire x2="1312" y1="992" y2="992" x1="1280" />
        </branch>
        <iomarker fontsize="28" x="1280" y="992" name="ce" orien="R180" />
        <branch name="c1">
            <wire x2="2576" y1="864" y2="864" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="864" name="c1" orien="R0" />
        <branch name="c2">
            <wire x2="2576" y1="928" y2="928" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="928" name="c2" orien="R0" />
        <branch name="c3">
            <wire x2="2576" y1="992" y2="992" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="992" name="c3" orien="R0" />
        <branch name="c4">
            <wire x2="2576" y1="1056" y2="1056" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1056" name="c4" orien="R0" />
        <branch name="c5">
            <wire x2="2576" y1="1120" y2="1120" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1120" name="c5" orien="R0" />
        <branch name="c6">
            <wire x2="2576" y1="1184" y2="1184" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1184" name="c6" orien="R0" />
        <branch name="c7">
            <wire x2="2576" y1="1248" y2="1248" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1248" name="c7" orien="R0" />
        <branch name="c8">
            <wire x2="2576" y1="1312" y2="1312" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1312" name="c8" orien="R0" />
        <branch name="c9">
            <wire x2="2576" y1="1376" y2="1376" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1376" name="c9" orien="R0" />
        <branch name="c10">
            <wire x2="2576" y1="1440" y2="1440" x1="2544" />
        </branch>
        <iomarker fontsize="28" x="2576" y="1440" name="c10" orien="R0" />
        <iomarker fontsize="28" x="448" y="1600" name="rst" orien="R180" />
        <branch name="XLXN_14">
            <wire x2="1136" y1="1344" y2="1344" x1="960" />
            <wire x2="1136" y1="1056" y2="1344" x1="1136" />
            <wire x2="1312" y1="1056" y2="1056" x1="1136" />
        </branch>
        <branch name="XLXN_16">
            <wire x2="1920" y1="736" y2="736" x1="1696" />
            <wire x2="1920" y1="736" y2="864" x1="1920" />
            <wire x2="2160" y1="864" y2="864" x1="1920" />
        </branch>
        <branch name="XLXN_17">
            <wire x2="1904" y1="800" y2="800" x1="1696" />
            <wire x2="1904" y1="800" y2="1152" x1="1904" />
            <wire x2="2160" y1="1152" y2="1152" x1="1904" />
        </branch>
        <branch name="XLXN_18">
            <wire x2="1888" y1="864" y2="864" x1="1696" />
            <wire x2="1888" y1="864" y2="1440" x1="1888" />
            <wire x2="2160" y1="1440" y2="1440" x1="1888" />
        </branch>
    </sheet>
</drawing>