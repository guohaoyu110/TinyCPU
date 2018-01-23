>信号未定义

- 出现位置：`Regsfile`的R0,R1,R2,R3,DR
- 报错信息：xxx未定义
- 错误原因：信号未定义
- 修改建议：
定义它们。

>with...select格式错误

- 出现位置：`Regsfile`，`DBUS`
- 报错信息：can't read 'out'什么什么,请使用'buffer'或'inout'
- 错误原因：with...select使用格式错误
- 修改建议：
  正确格式如下：
  ```
  with Choice select 
           Out <=  In0 after 2ns when "00",
                   In1 after 2ns when "01",
                   In2 after 2ns when "10",
                   In3 after 2ns when "11";
  ```

>端口长度不匹配

- 出现位置：
  - ①信号`AR`(16)与端口`Address`（8）
  - ②CUmem内部定义文件，输入的组合数据为40位，`CU_data`定义为48位  
  - ③alu_16bit中的`C_n_arith`，定义为16位，赋初值时为5位。
  - ④alu_16bit中148行，data_o_arith长度为17位，传入的长度为5位。
- 报错信息：端口长度不匹配
- 错误原因：同上
- 修改建议：
  - ①Address改为16位
  - ②......先注释了吧
  - ③第一，`C_n_arith`应为17位，第二，赋初值时扩充几个0。
    修改定义：
    ```
        signal C_n_arith : STD_LOGIC_VECTOR (16 downto 0);
    ```
    修改赋值：
    ```
        C_n_arith <= "0000000000000000" & (not C_n);
    ```
    这里注意如果改的是端口长度要改tinyCPU的声明以及内部定义两个文件。
  - ④data_sub_tmp符号位取反。
    ```
    data_o_arith <= not data_sub_tmp(16) & data_sub_tmp(15 downto 0);
    ```

>端口名信号名混淆

- 出现位置：tinycpu中241行的`cs`,`we`,`outnab`
- 报错信息：cs，we，outnab未定义
- 错误原因：cs,we,outnab是Dmem的端口，这里是需要的是可获取的信号
- 修改建议：
  ```
      Dio <= Dmem_in when (Dmem_cs = '1' and Dmem_we = '1' and Dmem_outenab = '0') else (others => 'Z');  
  ```

>其它

- 1.tinyCPU的两个输入端口名字都叫in_data1，改一改。
- 2.从`P004_时序逻辑LED点阵 `申请节点。
- 3.用哪个支撑包都行，但顶层文件要匹配，推荐用时序逻辑下的支撑包`RELAX_FlyxSOM_LED7SEG`。
- 4.从顶层文件绑定端口时，module名要匹配（默认tinyCPU）,要添加实例名。



