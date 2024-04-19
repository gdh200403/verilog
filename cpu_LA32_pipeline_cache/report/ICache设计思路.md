# ICache设计思路

## CPU和ICache的通信
- 发地址
  - 无异常时，每一拍持续送出raddr（虚地址 取PC[31:0]而非之前的[31:2]）一旦检测到addr_ready为1，则置addr_valid为1
  - inst_ready为1
  - icache检测到addr_valid为1，开始读取地址，若命中，icache将inst_valid置1，cpu接收指令，下一拍继续取指；否则icache进入MISS状态，将inst_valid置0，cpu流水线需要等待。inst_ready始终为1，等待icache的inst_valid置1
  - 这一拍，icache命中，一切正常
  - 这一拍，icache未命中，下一拍流水线需要暂停，则这一拍cpu置fstall
- 收指令
  - 若命中，这一拍经过icache的读取，cpu读到指令
  - 未命中，inst_ready始终为1，等待icache的inst_valid置1；在inst_valid置1的当拍，cpu读到指令

## 状态机

- LOOKUP: 读取地址，判断是否命中，在这一拍给出读取的数据
  - addr_ready = 1
  - inst_valid 根据是否命中置是否有效
  - request buffer写使能命中置0，不命中置1
  - 若未命中，inst_mem_raddr置为块起始地址，return buffer清零，准备好下一拍进入MISS状态
  - 命中，下一拍还为LOOKUP状态，保证连续读取
  - 命中，对应行的recently_hit置为路号
- MISS: 进入MISS状态后，这一拍读到来自IMEM异步给出的数据，并在return buffer进行拼接，inst_mem_raddr在下一拍递增，重复此过程，直到拼接完成
  - 对于这一拍读到的数据，下一拍return buffer才会锁存并进行拼接
  - 关闭request buffer写使能，同时addr_ready置0
  - 拼接完成信号：is_i_last = (inst_mem_raddr == 块结束地址) 组合逻辑
  - 这一拍，若inst_mem_raddr == cache锁存的raddr_reg，寄存器inst_from_retbuf更新，并锁存
  - 若这一拍，is_i_last = 1，下一拍进入REFILL状态
- REFILL
  - 这一拍，置选择信号is_data_from_cache为0，且置inst_valid = 1，使得cpu读取从IMEM加载的正确指令
  - 这一拍，根据windex对应行的recently_hit置相应路号的写使能，进行替换