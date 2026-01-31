// my initial file

#include "xil_exception.h"
#include "xil_printf.h"
#include "sleep.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xil_io.h"
#define CTRL_OFFSET 		0x00
#define INCREMET_OFFSET 	0x04
#define BURST_LEN_OFFSET 	0x08
#define BURST_PAUSE_OFFSET 	0x0C
int TrafGenInit(u32 DevAddr);
int DMAInit(XAxiDma *InstancePtrDMA, u16 DeviceId);

XAxiDma AxiDma;

int main() {
	int Status = XST_SUCCESS;
	int arr[128] = {0};
	xil_printf("Successfully launched!\r\n");
	Xil_DCacheDisable();
	// Setup DMA
	Status = DMAInit(&AxiDma, XPAR_AXI_DMA_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("[ERROR] DMA initialization failed!\r\n");
	} else {
		xil_printf("[INFO] DMA initialization success\r\n");
	}
	// Setup Traffic generator
	Status = TrafGenInit(XPAR_DATA_GEN_0_BASEADDR);
	if (Status != XST_SUCCESS) {
		xil_printf("[ERROR] Traffic generator initialization failed!\r\n");
	} else {
		xil_printf("[INFO] Traffic generator initialization success\r\n");
	}
	// run everything
	//Xil_DCacheInvalidateRange((UINTPTR)arr, 128*4);
	//dsb(); isb();
	Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR) &arr[0], 128*4,
	XAXIDMA_DEVICE_TO_DMA);
	while(XAxiDma_Busy(&AxiDma,XAXIDMA_DEVICE_TO_DMA));

	if (Status != XST_SUCCESS) {
		xil_printf("[ERROR] DMA Failed\r\n");
		return XST_FAILURE;
	}
	for (int i = 0; i < 16; i++) {
		xil_printf("arr[%d] = %08x\r\n", i, arr[i]);
	}
	return 0;
}

int TrafGenInit(u32 DevAddr) {
	int Status = XST_SUCCESS;

	Xil_Out32(DevAddr + BURST_LEN_OFFSET, 0x08);
	Xil_Out32(DevAddr + INCREMET_OFFSET, 0x01);
	Xil_Out32(DevAddr + CTRL_OFFSET, 0x0f);
	usleep(0.1);
	//Xil_Out32(DevAddr + CTRL_OFFSET, 0x00);
	return XST_SUCCESS;
}
int TrafGenStop(u32 DevAddr) {
	int Status = XST_SUCCESS;

	Xil_Out32(DevAddr + BURST_LEN_OFFSET, 0x08);
	Xil_Out32(DevAddr + INCREMET_OFFSET, 0x01);
	Xil_Out32(DevAddr + CTRL_OFFSET, 0x00);
	usleep(0.1);
	//Xil_Out32(DevAddr + CTRL_OFFSET, 0x00);
	return XST_SUCCESS;
}
int DMAInit(XAxiDma *InstancePtrDMA, u16 DeviceId) {
	XAxiDma_Config *CfgPtr;
	int Status;
	CfgPtr = XAxiDma_LookupConfig(DeviceId);
	if (!CfgPtr) {
		xil_printf("No configuration found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}
	XAxiDma_Reset(InstancePtrDMA);
	while (!XAxiDma_ResetIsDone(InstancePtrDMA)) { /* wait */ }
	Status = XAxiDma_CfgInitialize(InstancePtrDMA, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

    XAxiDma_IntrDisable(InstancePtrDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrAckIrq(InstancePtrDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	return XST_SUCCESS;
}
