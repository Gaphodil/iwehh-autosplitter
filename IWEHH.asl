state("I Wanna Escape Heavenly Host", "Post-Tourney 1")
{
    // couldn't find room ids
    double microseconds : 0x00445C40, 0x60, 0x10, 0x4E4, 0x310;
    double seconds      : 0x00445C40, 0x60, 0x10, 0x4E4, 0x320;
    double deaths       : 0x00445C40, 0x60, 0x10, 0x4E4, 0x330;
    // timerPopup: 0 most of the time, 1 on visual, back to 0 exactly on both timer start/end
    byte timerPopup     : 0x00443D4C, 0x0, 0xEB0, 0xC, 0x14, 0x1C, 0xD8;

    // items
    // 0 = unobtained, 1 = owned, 2 = used
    // 16*itemcount = byte array size
    // in every 8th byte with 16 offset: 0x0, 0x3F, or 0x40
    // it is probably cleaner to convert these to double arrays in update or split but w/e

    byte208 floorTwo    : 0x00445C40, 0x60, 0x10, 0x2F8, 0x0, 0x44, 0x14, 0x0;
    byte224 floorOne    : 0x00445C40, 0x60, 0x10, 0x2F8, 0x0, 0x44, 0x14, 0x140;

    // old implementation

    // 2F
    // double flower           : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904,  0xFD0;
    // double bottle           : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904,  0xFE0;
    // double knife            : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904,  0xFF0;
    // double gun              : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1000;
    // double coin             : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1010;
    // double toothbrush       : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1020;
    // double paperclip        : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1030;
    // double fruit            : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1040;
    // double pocketWatch      : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1050;
    // double rubberBand       : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1060;
    // double pencil           : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1070;
    // double phone            : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1080;
    // double stamp            : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1090;

    // 1F
    // double match            : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1110;
    // double holyWater        : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1120;
    // double umbrella         : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1130;
    // double note             : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1140; // skipped
    // double clip             : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1150; // unused
    // double die              : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1160;
    // double rubiksCube       : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1170;
    // double sponge           : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1180;
    // double tape             : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x1190;
    // double shovel           : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x11A0;
    // double minuteHand       : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x11B0;
    // double hourHand         : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x11C0;
    // double feather          : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x11D0;
    // double ink              : 0x00446CAC, 0x48, 0x8, 0x50, 0x18, 0x904, 0x11E0;
}

startup
{
    vars.currentFloor = 2;
    settings.Add("eachFloor", true, "Split Each Floor");
    settings.SetToolTip("eachFloor", "Split when your items are consumed and the gates are broken.");

    settings.Add("eachItem", true, "Split Each Item");
    settings.SetToolTip("eachItem", "Split on every item pickup (except in tower).");

    // for not re-splitting if you die after collecting an item
    bool[] noRepeatF2 = new bool[13];
    bool[] noRepeatF1 = new bool[14];
    vars.noRepeatF2 = noRepeatF2;
    vars.noRepeatF1 = noRepeatF1;
}

start
{
    vars.currentFloor = 2;
    Array.Clear(vars.noRepeatF2, 0, 13);
    Array.Clear(vars.noRepeatF1, 0, 14);

    return (current.seconds < 0.1 && current.microseconds > old.microseconds);
    // if (old.timerPopup == 1 && current.timerPopup == 0)
    // {
    //     return true;
    // }
}

reset
{
    // return to title screen
    return (old.timerPopup == 0 && current.seconds < 0.1 && current.microseconds < 0.1);
}

split
{
    Func<int, int> GetIndex = n => 7 + 16 * n;

    // some items are used and set to 2 early but most others will work
    if (settings["eachFloor"]
        && (current.floorTwo[GetIndex(12)] == 0x40 && vars.currentFloor == 2)
        || (current.floorOne[GetIndex(5)] == 0x40 && vars.currentFloor == 1))
    {
        vars.currentFloor--;
        return true;
    }


    if (settings["eachItem"]) {
        // the old implementation was a 24 item switch-case lmao
        // iterate every item
        for (int i = 0; i < 13; i++)
        {
            // if item is collected and not already split
            if (current.floorTwo[GetIndex(i)] == 0x3F && !vars.noRepeatF2[i])
            {
                // split
                vars.noRepeatF2[i] = true;
                return true;
            }
        }
        for (int i = 0; i < 14; i++)
        {
            if (current.floorOne[GetIndex(i)] == 0x3F && !vars.noRepeatF1[i])
            {
                vars.noRepeatF1[i] = true;
                return true;
            }
        }
    }

    // split if timerPopup switches from 1 to 0 (this should be the final split)
    // if (settings["finalSplit"] && timer.CurrentSplitIndex == timer.Run.Count - 1)
    if (old.timerPopup == 1 && current.timerPopup == 0)
    {
        return true;
    }
}

gameTime
{
    int sec = Convert.ToInt32(current.seconds);
    int milli = Convert.ToInt32(current.microseconds / 1000);
    return new TimeSpan(0, 0, 0, sec, milli);
}

isLoading
{
    return true;
}