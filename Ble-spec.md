BLE-Spec

Here you can find the Bluetooth Low Energy specification for a Self-driving RC car that we would like to release on market at the begining of the next year.

# Motion Service

Motion Service UUID is 0x21A2 and it contain only one characteristic: **MoveDriection**

# Move Direction
Characteristic UUID = 0x211

Move Direction characteristic can be read or subscribed.
It returns on of the following values:


| Byte        | Value           | Description  |
| ------------- |:-------------:| -----:|
| 0      | 1 | Forward |
| 0      | 2 | Backward |
| 0      | 3 | Left |
| 0      | 4 | Right |
| 0      | 5 | None |
