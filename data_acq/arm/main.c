#include "xil_printf.h"
#include "xparameters.h"
#include "xgpio_l.h"
#include "sleep.h"
#include "xllfifo_hw.h"
int main(){
    int status = 0;
    int fifo_value = 0;
    xil_printf("\r\nThis application is built on %s %s\r\n",__DATE__, __TIME__);
    status = XLlFifo_ReadReg(XPAR_AXI_FIFO_MM_S_0_BASEADDR,XLLF_RDFO_OFFSET);
    xil_printf("FIFO occupancy = %d\r\n",status);
    XLlFifo_print_reg_i(XPAR_AXI_FIFO_MM_S_0_BASEADDR,XLLF_RDFO_OFFSET,0);
    XGpio_WriteReg(XPAR_AXI_GPIO_0_BASEADDR,XGPIO_DATA_OFFSET,0x00);
    XGpio_WriteReg(XPAR_AXI_GPIO_0_BASEADDR,XGPIO_DATA2_OFFSET,0x03);
    XGpio_WriteReg(XPAR_AXI_GPIO_0_BASEADDR,XGPIO_DATA_OFFSET,0x03);
    usleep(10);
    XGpio_WriteReg(XPAR_AXI_GPIO_0_BASEADDR,XGPIO_DATA_OFFSET,0x00);
    status = XLlFifo_ReadReg(XPAR_AXI_FIFO_MM_S_0_BASEADDR,XLLF_RDFO_OFFSET);
    xil_printf("FIFO occupancy = %d\r\n",status);
    if (status > 10){
        for(int i=0;i<10;i++){
            fifo_value = XLlFifo_ReadReg(XPAR_AXI_FIFO_MM_S_0_BASEADDR,XLLF_RDFD_OFFSET);
            status = XLlFifo_ReadReg(XPAR_AXI_FIFO_MM_S_0_BASEADDR,XLLF_RDFO_OFFSET);
            xil_printf("Value #%i from FIFO: %d; ",i,fifo_value);
            xil_printf("now occupancy is %d\r\n",status);
        }
    }
    xil_printf("\r\n app finished\r\n");
    return 0;
}
