OUTPUT_DIR = bin
CONNECT_IQ_PATH=~/Library/Application\ Support/Garmin/ConnectIQ
DEVELOPER_KEY = $(CONNECT_IQ_PATH)/developer_key
SDK_PATH = $(CONNECT_IQ_PATH)/Sdks/connectiq-sdk-mac-8.1.0-2025-03-04-7ae1ed1cb
MONKEYC_PATH = $(SDK_PATH)/bin/monkeyc

build:
	$(MONKEYC_PATH) -f monkey.jungle -o $(OUTPUT_DIR)/24hAnalog.prg -d fenix7 -y $(DEVELOPER_KEY)

clean:
	rm -rf $(OUTPUT_DIR)/*