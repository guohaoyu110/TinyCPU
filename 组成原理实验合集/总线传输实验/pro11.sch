<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1(7:0)" />
        <signal name="XLXN_4(7:0)" />
        <signal name="XLXN_5(7:0)" />
        <signal name="clk" />
        <signal name="XLXN_7(7:0)" />
        <signal name="XLXN_8" />
        <signal name="we1" />
        <signal name="we2" />
        <signal name="oen" />
        <signal name="XLXN_12(7:0)" />
        <signal name="XLXN_13(7:0)" />
        <signal name="en_n" />
        <signal name="XLXN_15(7:0)" />
        <signal name="gwe" />
        <signal name="oen_n" />
        <port polarity="Input" name="clk" />
        <port polarity="Input" name="we1" />
        <port polarity="Input" name="we2" />
        <port polarity="Input" name="oen" />
        <port polarity="Input" name="XLXN_12(7:0)" />
        <port polarity="Output" name="XLXN_13(7:0)" />
        <port polarity="Input" name="en_n" />
        <port polarity="Output" name="XLXN_15(7:0)" />
        <port polarity="Input" name="gwe" />
        <port polarity="Input" name="oen_n" />
        <blockdef name="reg_74244">
            <timestamp>2013-4-24T7:37:8</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="reg_74377">
            <timestamp>2013-3-14T7:41:42</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="reg_74373">
            <timestamp>2013-3-14T7:41:36</timestamp>
            <rect width="256" x="64" y="-256" height="256" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-236" height="24" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
        </blockdef>
        <blockdef name="data_bus">
            <timestamp>2013-3-14T8:7:50</timestamp>
            <rect width="304" x="64" y="-704" height="1196" />
            <line x2="0" y1="-672" y2="-672" x1="64" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <rect width="64" x="0" y="-620" height="24" />
            <rect width="64" x="368" y="-156" height="24" />
            <line x2="432" y1="-144" y2="-144" x1="368" />
            <rect width="64" x="368" y="-284" height="24" />
            <line x2="432" y1="-272" y2="-272" x1="368" />
            <rect width="64" x="368" y="-412" height="24" />
            <line x2="432" y1="-400" y2="-400" x1="368" />
            <line x2="432" y1="-544" y2="-544" x1="368" />
            <rect width="64" x="368" y="-556" height="24" />
            <line x2="0" y1="432" y2="432" x1="64" />
            <line x2="0" y1="336" y2="336" x1="64" />
            <line x2="0" y1="240" y2="240" x1="64" />
            <line x2="0" y1="144" y2="144" x1="64" />
            <line x2="0" y1="-448" y2="-448" x1="64" />
            <rect width="64" x="0" y="-460" height="24" />
            <rect width="64" x="0" y="-316" height="24" />
            <line x2="0" y1="-304" y2="-304" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="48" y2="48" x1="64" />
            <line x2="0" y1="-48" y2="-48" x1="64" />
            <rect width="64" x="368" y="244" height="24" />
            <line x2="432" y1="256" y2="256" x1="368" />
            <line x2="432" y1="96" y2="96" x1="368" />
            <rect width="64" x="368" y="84" height="24" />
        </blockdef>
        <blockdef name="gnd">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-96" x1="64" />
            <line x2="52" y1="-48" y2="-48" x1="76" />
            <line x2="60" y1="-32" y2="-32" x1="68" />
            <line x2="40" y1="-64" y2="-64" x1="88" />
            <line x2="64" y1="-64" y2="-80" x1="64" />
            <line x2="64" y1="-128" y2="-96" x1="64" />
        </blockdef>
        <block symbolname="reg_74244" name="XLXI_1">
            <blockpin signalname="oen" name="oen" />
            <blockpin signalname="XLXN_12(7:0)" name="Din(7:0)" />
            <blockpin signalname="XLXN_1(7:0)" name="Qout(7:0)" />
        </block>
        <block symbolname="reg_74377" name="XLXI_2">
            <blockpin signalname="clk" name="clk" />
            <blockpin signalname="en_n" name="en_n" />
            <blockpin signalname="XLXN_4(7:0)" name="Din(7:0)" />
            <blockpin signalname="XLXN_13(7:0)" name="Qout(7:0)" />
        </block>
        <block symbolname="reg_74373" name="XLXI_3">
            <blockpin signalname="clk" name="clk" />
            <blockpin signalname="gwe" name="gwe" />
            <blockpin signalname="oen_n" name="oen_n" />
            <blockpin signalname="XLXN_5(7:0)" name="Din(7:0)" />
            <blockpin signalname="XLXN_7(7:0)" name="Qout(7:0)" />
        </block>
        <block symbolname="data_bus" name="XLXI_4">
            <blockpin signalname="clk" name="clk" />
            <blockpin signalname="XLXN_1(7:0)" name="data_in1(7:0)" />
            <blockpin name="data_out4(7:0)" />
            <blockpin signalname="XLXN_15(7:0)" name="data_out3(7:0)" />
            <blockpin signalname="XLXN_5(7:0)" name="data_out2(7:0)" />
            <blockpin signalname="XLXN_4(7:0)" name="data_out1(7:0)" />
            <blockpin signalname="XLXN_8" name="we_io2" />
            <blockpin signalname="XLXN_8" name="we_io1" />
            <blockpin signalname="XLXN_8" name="we4" />
            <blockpin signalname="XLXN_8" name="we3" />
            <blockpin signalname="XLXN_7(7:0)" name="data_in2(7:0)" />
            <blockpin name="data_in3(7:0)" />
            <blockpin name="data_in4(7:0)" />
            <blockpin signalname="we2" name="we2" />
            <blockpin signalname="we1" name="we1" />
            <blockpin name="data_io2(7:0)" />
            <blockpin name="data_io1(7:0)" />
        </block>
        <block symbolname="gnd" name="XLXI_5">
            <blockpin signalname="XLXN_8" name="G" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="2400" y="640" name="XLXI_2" orien="R0">
        </instance>
        <instance x="2416" y="1872" name="XLXI_3" orien="R0">
        </instance>
        <instance x="1280" y="1280" name="XLXI_4" orien="R0">
        </instance>
        <instance x="400" y="800" name="XLXI_1" orien="R0">
        </instance>
        <branch name="XLXN_1(7:0)">
            <wire x2="1024" y1="640" y2="640" x1="784" />
            <wire x2="1024" y1="640" y2="672" x1="1024" />
            <wire x2="1280" y1="672" y2="672" x1="1024" />
        </branch>
        <branch name="XLXN_4(7:0)">
            <wire x2="2048" y1="736" y2="736" x1="1712" />
            <wire x2="2048" y1="608" y2="736" x1="2048" />
            <wire x2="2400" y1="608" y2="608" x1="2048" />
        </branch>
        <branch name="XLXN_5(7:0)">
            <wire x2="2064" y1="880" y2="880" x1="1712" />
            <wire x2="2064" y1="880" y2="1840" x1="2064" />
            <wire x2="2416" y1="1840" y2="1840" x1="2064" />
        </branch>
        <branch name="clk">
            <wire x2="1248" y1="608" y2="608" x1="1200" />
            <wire x2="1280" y1="608" y2="608" x1="1248" />
            <wire x2="1776" y1="304" y2="304" x1="1248" />
            <wire x2="1776" y1="304" y2="472" x1="1776" />
            <wire x2="1776" y1="472" y2="480" x1="1776" />
            <wire x2="1776" y1="480" y2="1648" x1="1776" />
            <wire x2="2416" y1="1648" y2="1648" x1="1776" />
            <wire x2="2400" y1="480" y2="480" x1="1776" />
            <wire x2="1248" y1="304" y2="608" x1="1248" />
        </branch>
        <iomarker fontsize="28" x="1200" y="608" name="clk" orien="R180" />
        <branch name="XLXN_7(7:0)">
            <wire x2="1280" y1="832" y2="832" x1="1200" />
            <wire x2="1200" y1="832" y2="1920" x1="1200" />
            <wire x2="2880" y1="1920" y2="1920" x1="1200" />
            <wire x2="2880" y1="1648" y2="1648" x1="2800" />
            <wire x2="2880" y1="1648" y2="1920" x1="2880" />
        </branch>
        <instance x="1184" y="2096" name="XLXI_5" orien="R0" />
        <branch name="XLXN_8">
            <wire x2="1280" y1="1424" y2="1424" x1="1248" />
            <wire x2="1248" y1="1424" y2="1520" x1="1248" />
            <wire x2="1280" y1="1520" y2="1520" x1="1248" />
            <wire x2="1248" y1="1520" y2="1616" x1="1248" />
            <wire x2="1280" y1="1616" y2="1616" x1="1248" />
            <wire x2="1248" y1="1616" y2="1712" x1="1248" />
            <wire x2="1248" y1="1712" y2="1968" x1="1248" />
            <wire x2="1280" y1="1712" y2="1712" x1="1248" />
        </branch>
        <branch name="we1">
            <wire x2="1280" y1="1232" y2="1232" x1="1248" />
        </branch>
        <iomarker fontsize="28" x="1248" y="1232" name="we1" orien="R180" />
        <branch name="we2">
            <wire x2="1280" y1="1328" y2="1328" x1="1248" />
        </branch>
        <iomarker fontsize="28" x="1248" y="1328" name="we2" orien="R180" />
        <branch name="oen">
            <wire x2="400" y1="704" y2="704" x1="368" />
        </branch>
        <iomarker fontsize="28" x="368" y="704" name="oen" orien="R180" />
        <branch name="XLXN_12(7:0)">
            <wire x2="400" y1="768" y2="768" x1="368" />
        </branch>
        <iomarker fontsize="28" x="368" y="768" name="XLXN_12(7:0)" orien="R180" />
        <branch name="XLXN_13(7:0)">
            <wire x2="2816" y1="480" y2="480" x1="2784" />
        </branch>
        <iomarker fontsize="28" x="2816" y="480" name="XLXN_13(7:0)" orien="R0" />
        <branch name="en_n">
            <wire x2="2400" y1="544" y2="544" x1="2368" />
        </branch>
        <iomarker fontsize="28" x="2368" y="544" name="en_n" orien="R180" />
        <branch name="XLXN_15(7:0)">
            <wire x2="1744" y1="1008" y2="1008" x1="1712" />
        </branch>
        <iomarker fontsize="28" x="1744" y="1008" name="XLXN_15(7:0)" orien="R0" />
        <branch name="gwe">
            <wire x2="2416" y1="1712" y2="1712" x1="2384" />
        </branch>
        <iomarker fontsize="28" x="2384" y="1712" name="gwe" orien="R180" />
        <branch name="oen_n">
            <wire x2="2416" y1="1776" y2="1776" x1="2384" />
        </branch>
        <iomarker fontsize="28" x="2384" y="1776" name="oen_n" orien="R180" />
    </sheet>
</drawing>