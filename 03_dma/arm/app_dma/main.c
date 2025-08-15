// my initial file

#include "xil_exception.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xtrafgen.h"
#include "xaxidma.h"

int TrafGenInit(XTrafGen *InstancePtrTrafGen, u16 DeviceId);
int DMAInit(XAxiDma *InstancePtrDMA, u16 DeviceId);

XTrafGen XTrafGenInstance;
XAxiDma AxiDma;

int main() {
	int Status = XST_SUCCESS;
	int arr[16];
	xil_printf("Successfully launched!\r\n");
	// Setup Traffic generator
	Status = TrafGenInit(&XTrafGenInstance, XPAR_AXI_TRAFFIC_GEN_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("[ERROR] Traffic generator initialization failed!\r\n");
	} else {
		xil_printf("[INFO] Traffic generator initialization success\r\n");
	}
	// Setup DMA
	Status = DMAInit(&AxiDma, XPAR_AXI_DMA_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("[ERROR] DMA initialization failed!\r\n");
	} else {
		xil_printf("[INFO] DMA initialization success\r\n");
	}
	// run everything

	XTrafGen_ResetStreamingRandomLen(&XTrafGenInstance);
	XTrafGen_SetStreamingTransLen(&XTrafGenInstance, 8);
	XTrafGen_SetStreamingTransCnt(&XTrafGenInstance, 2);
	/* Enable the traffic generation */
	XTrafGen_StreamEnable(&XTrafGenInstance);

	Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) &arr, 16,
	XAXIDMA_DEVICE_TO_DMA);

	if (Status != XST_SUCCESS) {
		xil_printf("[ERROR] DMA Failed\r\n");
		return XST_FAILURE;
	}
	for (int i=0;i<16;i++){
		xil_printf("arr[%d] = %08x\r\n",i,arr[i]);
	}
	return 0;
}

int TrafGenInit(XTrafGen *InstancePtrTrafGen, u16 DeviceId) {
	int Status = XST_SUCCESS;
	XTrafGen_Config *XTrafConfig;
	XTrafConfig = XTrafGen_LookupConfig(DeviceId);
	if (!XTrafConfig) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	Status = XTrafGen_CfgInitialize(InstancePtrTrafGen, XTrafConfig,
			XTrafConfig->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed\n\r");
		return Status;
	}

	/* Check for the Streaming Mode */
	if (XTrafGenInstance.OperatingMode != XTG_MODE_STREAMING) {
		xil_printf("Operation mode is not a stream as expected\r\n");
		return XST_FAILURE;
	}
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
	Status = XAxiDma_CfgInitialize(InstancePtrDMA, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
