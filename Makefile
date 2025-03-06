OUTPUT_DIR = bin
MONKEYC_PATH = ~/Library/Application\ Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.0.0_Beta-2025-01-07-276916717/bin/monkeyc
DEVELOPER_KEY = ~/Library/Application\ Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.0.0_Beta-2025-01-07-276916717/bin/developer_key

build:
	$(MONKEYC_PATH) -f monkey.jungle -o $(OUTPUT_DIR)/24hAnalog.prg -d fenix7 -y $(DEVELOPER_KEY)

clean:
	rm -rf $(OUTPUT_DIR)/*