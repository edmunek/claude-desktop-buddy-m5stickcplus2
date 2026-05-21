$srcPath = "C:\Users\edmun\Downloads\claude-desktop-buddy\src"
$files = Get-ChildItem -Path $srcPath -Recurse -Include "*.cpp","*.h"

foreach ($file in $files) {
    $c = Get-Content $file.FullName -Raw

    # Graphics
    $c = $c -replace 'class TFT_eSPI;', ''
    $c = $c -replace 'TFT_eSPI\s*\*', 'lgfx::LovyanGFX*'

    # Speaker (Beep -> Speaker)
    $c = $c -replace 'M5\.Beep\.tone', 'M5.Speaker.tone'
    $c = $c -replace 'M5\.Beep\.begin\(\)', 'M5.Speaker.begin()'
    $c = $c -replace 'M5\.Beep\.update\(\)', 'M5.Speaker.update()'

    # IMU
    $c = $c -replace 'M5\.Imu\.Init\(\)', 'M5.Imu.init()'

    # RTC types
    $c = $c -replace 'RTC_TimeTypeDef', 'm5::rtc_time_t'
    $c = $c -replace 'RTC_DateTypeDef', 'm5::rtc_date_t'

    # RTC methods
    $c = $c -replace 'M5\.Rtc\.SetTime', 'M5.Rtc.setTime'
    $c = $c -replace 'M5\.Rtc\.SetDate', 'M5.Rtc.setDate'
    $c = $c -replace 'M5\.Rtc\.GetTime', 'M5.Rtc.getTime'
    $c = $c -replace 'M5\.Rtc\.GetDate', 'M5.Rtc.getDate'

    # RTC struct fields
    $c = $c -replace '_clkTm\.Hours', '_clkTm.hours'
    $c = $c -replace '_clkTm\.Minutes', '_clkTm.minutes'
    $c = $c -replace '_clkDt\.WeekDay', '_clkDt.weekDay'
    $c = $c -replace '_clkDt\.Month', '_clkDt.month'

    # Power management
    $c = $c -replace 'M5\.Axp\.PowerOff\(\)', 'M5.Power.powerOff()'
    $c = $c -replace 'M5\.Axp\.ScreenBreath\(', 'M5.Lcd.setBrightness('
    $c = $c -replace 'M5\.Axp\.SetLDO2\(true\)', 'M5.Lcd.setBrightness(128)'
    $c = $c -replace 'M5\.Axp\.SetLDO2\(false\)', 'M5.Lcd.setBrightness(0)'
    $c = $c -replace '\(int\)\(M5\.Axp\.GetBatVoltage\(\) \* 1000\)', 'M5.Power.getBatteryVoltage()'
    $c = $c -replace '\(int\)M5\.Axp\.GetBatCurrent\(\)', '(int)M5.Power.getBatteryCurrent()'
    $c = $c -replace '\(int\)\(M5\.Axp\.GetVBusVoltage\(\) \* 1000\)', '0'
    $c = $c -replace 'M5\.Axp\.GetVBusVoltage\(\) > 4\.0f', 'M5.Power.isCharging()'
    $c = $c -replace '\(int\)M5\.Axp\.GetTempInAXP192\(\)', '0'
    $c = $c -replace 'M5\.Axp\.GetBtnPress\(\) == 0x02', 'M5.BtnPWR.wasClicked()'

    [System.IO.File]::WriteAllText($file.FullName, $c)
}
Write-Host "Done!"