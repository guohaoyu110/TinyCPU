<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="XLXN_2" />
        <signal name="A(3:0)" />
        <signal name="B(3:0)" />
        <signal name="S(3:0)" />
        <signal name="XLXN_6" />
        <signal name="F(3:0)" />
        <port polarity="Input" name="XLXN_1" />
        <port polarity="Input" name="XLXN_2" />
        <port polarity="Input" name="A(3:0)" />
        <port polarity="Input" name="B(3:0)" />
        <port polarity="Input" name="S(3:0)" />
        <port polarity="Output" name="XLXN_6" />
        <port polarity="Output" name="F(3:0)" />
        <blockdef name="alu_74181">
            <timestamp>2013-4-24T2:42:26</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <block symbolname="alu_74181" name="XLXI_1">
            <blockpin signalname="XLXN_1" name="M" />
            <blockpin signalname="XLXN_2" name="C_n" />
            <blockpin signalname="A(3:0)" name="A(3:0)" />
            <blockpin signalname="B(3:0)" name="B(3:0)" />
            <blockpin signalname="S(3:0)" name="S(3:0)" />
            <blockpin signalname="XLXN_6" name="C_n_plus4" />
            <blockpin signalname="F(3:0)" name="F(3:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1568" y="1344" name="XLXI_1" orien="R0">
        </instance>
        <branch name="XLXN_1">
            <wire x2="1568" y1="1056" y2="1056" x1="1536" />
        </branch>
        <iomarker fontsize="28" x="1536" y="1056" name="XLXN_1" orien="R180" />
        <branch name="XLXN_2">
            <wire x2="1568" y1="1120" y2="1120" x1="1536" />
        </branch>
        <iomarker fontsize="28" x="1536" y="1120" name="XLXN_2" orien="R180" />
        <branch name="A(3:0)">
            <wire x2="1568" y1="1184" y2="1184" x1="1536" />
        </branch>
        <iomarker fontsize="28" x="1536" y="1184" name="A(3:0)" orien="R180" />
        <branch name="B(3:0)">
            <wire x2="1568" y1="1248" y2="1248" x1="1536" />
        </branch>
        <iomarker fontsize="28" x="1536" y="1248" name="B(3:0)" orien="R180" />
        <branch name="S(3:0)">
            <wire x2="1568" y1="1312" y2="1312" x1="1536" />
        </branch>
        <iomarker fontsize="28" x="1536" y="1312" name="S(3:0)" orien="R180" />
        <branch name="XLXN_6">
            <wire x2="1984" y1="1056" y2="1056" x1="1952" />
        </branch>
        <iomarker fontsize="28" x="1984" y="1056" name="XLXN_6" orien="R0" />
        <branch name="F(3:0)">
            <wire x2="1984" y1="1312" y2="1312" x1="1952" />
        </branch>
        <iomarker fontsize="28" x="1984" y="1312" name="F(3:0)" orien="R0" />
    </sheet>
</drawing>