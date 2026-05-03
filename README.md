# DigitalClock - 数字钟 FPGA 设计

基于 **Quartus II 9.0 SP2** 的 Altera Stratix II FPGA 数字钟项目。

## 功能

- **计时**：60 进制秒/分 + 24 进制小时，支持手动调时
- **显示**：6 位数码管动态扫描显示 (HH:MM:SS)
- **闹钟**：可设置闹钟时间，到达后蜂鸣器输出变频音

## 模块结构

```
DigitalClock (顶层)
├── MOD_60        ×2  秒/分 60 进制计数器
├── MOD_24        ×1  小时 24 进制计数器
├── carry_60      ×2  59 进位检测
├── Decoder_2to4  ×1  2-4 译码器 (位选扫描)
├── BCD_7         ×1  BCD 转 7 段数码管
├── alarm_storage ×2  闹钟时间存储 (分/时)
├── alarm_judge   ×1  闹钟比较判断
├── speaker       ×1  蜂鸣器分频
└── depart        ×1  闹钟输出控制
```

## 顶层端口

| 端口 | 位宽 | 方向 | 说明 |
|------|------|------|------|
| `CLK_1HZ` | 1 | I | 1Hz 计时时钟 |
| `CLK_SCAN` | 1 | I | 数码管扫描时钟 |
| `CLK_SPK` | 1 | I | 蜂鸣器音频时钟 |
| `nRST` | 1 | I | 低有效复位 |
| `ADJ_MIN` | 1 | I | 手动调分 |
| `ADJ_HOUR` | 1 | I | 手动调时 |
| `ALM_EN` | 1 | I | 闹钟使能 |
| `ALM_SET_MIN` | 1 | I | 设置闹钟分钟 |
| `ALM_SET_HOUR` | 1 | I | 设置闹钟小时 |
| `ALM_SW1` | 4 | I | 闹钟 BCD 十位拨码 |
| `ALM_SW0` | 4 | I | 闹钟 BCD 个位拨码 |
| `SEG` | 7 | O | 7 段数码管 a~g |
| `DIG` | 6 | O | 位选信号 (低有效) |
| `BUZZER` | 1 | O | 蜂鸣器输出 |

## 开发环境

- **FPGA**：Altera Stratix II
- **工具**：Quartus II 9.0 SP2 Web Edition
- **语言**：Verilog HDL
