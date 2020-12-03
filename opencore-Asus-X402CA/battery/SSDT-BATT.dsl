/*

 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "BATT", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC0, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0.XACH, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.ECAV, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.XBIX, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.BATP, MethodObj)
    External (_SB_.PCI0.NBIX,PkgObj)
    External (_SB_.PCI0.LPCB.EC0.GBTT, MethodObj)
    External (_SB_.PCI0.LPCB.EC0._BIF, MethodObj)
    External (_SB_.PCI0.PBIF,PkgObj)
    External (_SB_.PCI0.BIXT,PkgObj)
    External (_SB_.PCI0.LPCB.EC0.XIFA, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.BSLF, IntObj)
    External (_SB_.PCI0.LPCB.EC0.RDBL, IntObj)
    External (_SB_.PCI0.LPCB.EC0.RDWD, IntObj)
    External (_SB_.PCI0.LPCB.EC0.RDBT, IntObj)
    External (_SB_.PCI0.LPCB.EC0.RCBT, IntObj)
    External (_SB_.PCI0.LPCB.EC0.RDQK, IntObj)
    External (_SB_.PCI0.LPCB.EC0.MUEC, MutexObj)
    External (_SB_.PCI0.LPCB.EC0.SBBY, IntObj)
    External (_SB_.PCI0.LPCB.EC0.SWTC, MethodObj)
    External (DT2B, FieldUnitObj)
    External (DAT0, FieldUnitObj)
    External (DAT1, FieldUnitObj)
    External (DA20, FieldUnitObj)
    External (DA21, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC0.XMBR, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.WRBL, IntObj)
    External (_SB_.PCI0.LPCB.EC0.WRWD, IntObj)
    External (_SB_.PCI0.LPCB.EC0.WRBT, IntObj)
    External (_SB_.PCI0.LPCB.EC0.SDBT, IntObj)
    External (_SB_.PCI0.LPCB.EC0.WRQK, IntObj)
    External (_SB_.PCI0.LPCB.EC0.XMBW, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.XCSB, MethodObj)




    Method (B1B2, 2, NotSerialized)
    {
        Return ((Arg0 | (Arg1 << 0x08)))
    }

    Method (B1B4, 4, NotSerialized)
    {
        Local0 = (Arg2 | (Arg3 << 0x08))
        Local0 = (Arg1 | (Local0 << 0x08))
        Local0 = (Arg0 | (Local0 << 0x08))
        Return (Local0)
    }

    Method (W16B, 3, NotSerialized)
    {
        Arg0 = Arg2
        Arg1 = (Arg2 >> 0x08)
    }

    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            Return (BYTE) 
        }

        Method (RECB, 2, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1){})
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                TEMP [Local0] = RE1B (Arg0)
                Arg0++
                Local0++
            }

            Return (TEMP)
        }

        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion (ERM2, EmbeddedControl, Arg0, One)
            Field (ERM2, ByteAcc, NoLock, Preserve)
            {
                BYTE,   8
            }

            BYTE = Arg1
        }

        Method (WECB, 3, Serialized)
        {
            Arg1 = ((Arg1 + 0x07) >> 0x03)
            Name (TEMP, Buffer (Arg1){})
            TEMP = Arg2
            Arg1 += Arg0
            Local0 = Zero
            While ((Arg0 < Arg1))
            {
                WE1B (Arg0, DerefOf (TEMP [Local0]))
                Arg0++
                Local0++
            }
        }
        
            OperationRegion (XCOR, EmbeddedControl, Zero, 0xFF)
            Field (XCOR, ByteAcc, Lock, Preserve)
            {

 

                Offset (0x93), 
                //TAH0,   16,
                TA00,    8,
                TA01,    8, 
                //TAH1,   16, 
                TA10,    8,
                TA11,    8,

                Offset (0xBE), 

 
                Offset (0xBE), 
                B0TM,   16, 
                B0C1,   16, 
                B0C2,   16, 
                //B0C3,   16,
                X0C0,    8,
                X0C1,    8,
                

                Offset (0xF4), 
                //B0SN,   16,
                X0S0,    8,
                X0S1,    8,

                Offset (0xFC), 
                //B1SN,   16
                X1S0,    8,
                X1S1,    8
            }
            
        Method (TACH, 1, Serialized)
        {
            If (_OSI("Darwin")) {
            If (ECAV ())
            {
                Switch (Arg0)
                {
                    Case (Zero)
                    {
                        //Store (TAH0, Local0)
                        Store(B1B2(TA00, TA01), Local0)
                        Break
                    }
                    Case (One)
                    {
                        //Store (TAH1, Local0)
                        Store(B1B2(TA10, TA11), Local0)
                        Break
                    }
                    Default
                    {
                        Return (Ones)
                    }

                }

                Multiply (Local0, 0x02, Local0)
                If (LNotEqual (Local0, Zero))
                {
                    Divide (0x0041CDB4, Local0, Local1, Local0)
                    Return (Local0)
                }
                Else
                {
                    Return (Ones)
                }
            }
            Else
            {
                Return (Ones)
            }
            } else {
                return(XACH(Arg0))
            }
        }
            
            Method (_BIX, 0, NotSerialized)  // _BIX: Battery Information Extended
            {
                If (_OSI("Darwin")) {
                If (LNot (BATP (Zero)))
                {
                    Return (NBIX)
                }

                If (LEqual (GBTT (Zero), 0xFF))
                {
                    Return (NBIX)
                }

                _BIF ()
                Store (DerefOf (Index (PBIF, Zero)), Index (BIXT, One))
                Store (DerefOf (Index (PBIF, One)), Index (BIXT, 0x02))
                Store (DerefOf (Index (PBIF, 0x02)), Index (BIXT, 0x03))
                Store (DerefOf (Index (PBIF, 0x03)), Index (BIXT, 0x04))
                Store (DerefOf (Index (PBIF, 0x04)), Index (BIXT, 0x05))
                Store (DerefOf (Index (PBIF, 0x05)), Index (BIXT, 0x06))
                Store (DerefOf (Index (PBIF, 0x06)), Index (BIXT, 0x07))
                Store (DerefOf (Index (PBIF, 0x07)), Index (BIXT, 0x08))
                Store (DerefOf (Index (PBIF, 0x08)), Index (BIXT, 0x09))
                Store (DerefOf (Index (PBIF, 0x09)), Index (BIXT, 0x10))
                Store (DerefOf (Index (PBIF, 0x0A)), Index (BIXT, 0x11))
                Store (DerefOf (Index (PBIF, 0x0B)), Index (BIXT, 0x12))
                Store (DerefOf (Index (PBIF, 0x0C)), Index (BIXT, 0x13))
                If (LEqual (DerefOf (Index (BIXT, One)), One))
                {
                    Store (Zero, Index (BIXT, One))
                    Store (DerefOf (Index (BIXT, 0x05)), Local0)
                    Multiply (DerefOf (Index (BIXT, 0x02)), Local0, Index (BIXT, 0x02))
                    Multiply (DerefOf (Index (BIXT, 0x03)), Local0, Index (BIXT, 0x03))
                    Multiply (DerefOf (Index (BIXT, 0x06)), Local0, Index (BIXT, 0x06))
                    Multiply (DerefOf (Index (BIXT, 0x07)), Local0, Index (BIXT, 0x07))
                    Multiply (DerefOf (Index (BIXT, 0x08)), Local0, Index (BIXT, 0x08))
                    Multiply (DerefOf (Index (BIXT, 0x09)), Local0, Index (BIXT, 0x09))
                    Divide (DerefOf (Index (BIXT, 0x02)), 0x03E8, Local0, Index (BIXT, 0x02))
                    Divide (DerefOf (Index (BIXT, 0x03)), 0x03E8, Local0, Index (BIXT, 0x03))
                    Divide (DerefOf (Index (BIXT, 0x06)), 0x03E8, Local0, Index (BIXT, 0x06))
                    Divide (DerefOf (Index (BIXT, 0x07)), 0x03E8, Local0, Index (BIXT, 0x07))
                    Divide (DerefOf (Index (BIXT, 0x08)), 0x03E8, Local0, Index (BIXT, 0x08))
                    Divide (DerefOf (Index (BIXT, 0x09)), 0x03E8, Local0, Index (BIXT, 0x09))
                }

                //Store (^^LPCB.EC0.B0C3, Index (BIXT, 0x0A))
                Store(B1B2(X0C0, X0C1),Index (BIXT, 0x0A)) 
                Store (0x0001869F, Index (BIXT, 0x0B))
                Return (BIXT) }
                else {
                    return XBIX()
                 }
            }
            
        Method (BIFA, 0, NotSerialized)
        {
            If (_OSI("Darwin")) {
                
            If (ECAV ())
            {
                If (BSLF)
                {
                    //Store (B1SN, Local0)
                    Store(B1B2(X1S0, X1S1), Local0)
                }
                Else
                {
                    //Store (B0SN, Local0)
                    Store(B1B2(X0S0, X0S1), Local0)

                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0) }
            else {
                return XIFA()
                }
        }
        
            OperationRegion (XMBX, EmbeddedControl, 0x18, 0x28)
            Field (XMBX, ByteAcc, NoLock, Preserve)
            {
                PRTC,   8, 
                SSTS,   5, 
                    ,   1, 
                ALFG,   1, 
                CDFG,   1, 
                ADDR,   8, 
                CMDB,   8, 
                BDAT,   256, 
                BCNT,   8, 
                    ,   1, 
                ALAD,   7, 
                ALD0,   8, 
                ALD1,   8
            }
        Method (SMBR, 3, Serialized)
        {
            If (_OSI("Darwin")) {

             
            Store (Package (0x03)
                {
                    0x07, 
                    Zero, 
                    Zero
                }, Local0)
            If (LNot (ECAV ()))
            {
                Return (Local0)
            }

            If (LNotEqual (Arg0, RDBL))
            {
                If (LNotEqual (Arg0, RDWD))
                {
                    If (LNotEqual (Arg0, RDBT))
                    {
                        If (LNotEqual (Arg0, RCBT))
                        {
                            If (LNotEqual (Arg0, RDQK))
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Store (PRTC, Local1)
            Store (Zero, Local2)
            While (LNotEqual (Local1, Zero))
            {
                Stall (0x0A)
                Increment (Local2)
                If (LGreater (Local2, 0x03E8))
                {
                    Store (SBBY, Index (Local0, Zero))
                    Store (Zero, Local1)
                }
                Else
                {
                    Store (PRTC, Local1)
                }
            }

            If (LLessEqual (Local2, 0x03E8))
            {
                ShiftLeft (Arg1, One, Local3)
                Or (Local3, One, Local3)
                Store (Local3, ADDR)
                If (LNotEqual (Arg0, RDQK))
                {
                    If (LNotEqual (Arg0, RCBT))
                    {
                        Store (Arg2, CMDB)
                    }
                }

                //Store (Zero, BDAT)
                WECB(0x1c,256, Zero)
                Store (Arg0, PRTC)
                Store (SWTC (Arg0), Index (Local0, Zero))
                If (LEqual (DerefOf (Index (Local0, Zero)), Zero))
                {
                    If (LEqual (Arg0, RDBL))
                    {
                        Store (BCNT, Index (Local0, One))
                        //Store (BDAT, Index (Local0, 0x02))
                        Store(RECB(0x1c,256), Index (Local0, 0x02))
                    }

                    If (LEqual (Arg0, RDWD))
                    {
                        Store (0x02, Index (Local0, One))
                        Store (DT2B, Index (Local0, 0x02))
                    }

                    If (LEqual (Arg0, RDBT))
                    {
                        Store (One, Index (Local0, One))
                        Store (DAT0, Index (Local0, 0x02))
                    }

                    If (LEqual (Arg0, RCBT))
                    {
                        Store (One, Index (Local0, One))
                        Store (DAT0, Index (Local0, 0x02))
                    }
                }
            }

            Release (MUEC)
            Return (Local0) }
        else {
            Return XMBR(Arg0, Arg1, Arg2)
            }
        }

        Method (SMBW, 5, Serialized)
        {
            If (_OSI("Darwin")) {
            Store (Package (0x01)
                {
                    0x07
                }, Local0)
            If (LNot (ECAV ()))
            {
                Return (Local0)
            }

            If (LNotEqual (Arg0, WRBL))
            {
                If (LNotEqual (Arg0, WRWD))
                {
                    If (LNotEqual (Arg0, WRBT))
                    {
                        If (LNotEqual (Arg0, SDBT))
                        {
                            If (LNotEqual (Arg0, WRQK))
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            Acquire (MUEC, 0xFFFF)
            Store (PRTC, Local1)
            Store (Zero, Local2)
            While (LNotEqual (Local1, Zero))
            {
                Stall (0x0A)
                Increment (Local2)
                If (LGreater (Local2, 0x03E8))
                {
                    Store (SBBY, Index (Local0, Zero))
                    Store (Zero, Local1)
                }
                Else
                {
                    Store (PRTC, Local1)
                }
            }

            If (LLessEqual (Local2, 0x03E8))
            {
                //Store (Zero, BDAT)
                WECB(0x1c,256, Zero)
                ShiftLeft (Arg1, One, Local3)
                Store (Local3, ADDR)
                If (LNotEqual (Arg0, WRQK))
                {
                    If (LNotEqual (Arg0, SDBT))
                    {
                        Store (Arg2, CMDB)
                    }
                }

                If (LEqual (Arg0, WRBL))
                {
                    Store (Arg3, BCNT)
                    //Store (Arg4, BDAT)
                    WECB(0x1, 256, Arg4)
                }

                If (LEqual (Arg0, WRWD))
                {
                    Store (Arg4, DT2B)
                }

                If (LEqual (Arg0, WRBT))
                {
                    Store (Arg4, DAT0)
                }

                If (LEqual (Arg0, SDBT))
                {
                    Store (Arg4, DAT0)
                }

                Store (Arg0, PRTC)
                Store (SWTC (Arg0), Index (Local0, Zero))
            }

            Release (MUEC)
            Return (Local0) }
        else {
                Return XMBW(Arg0, Arg1, Arg2, Arg3, Arg4)
            }
        }
        
            OperationRegion (XMB2, EmbeddedControl, 0x40, 0x28)
            Field (XMB2, ByteAcc, NoLock, Preserve)
            {
                PRT2,   8, 
                SST2,   5, 
                    ,   1, 
                ALF2,   1, 
                CDF2,   1, 
                ADD2,   8, 
                CMD2,   8, 
                BDA2,   256, 
                BCN2,   8, 
                    ,   1, 
                ALA2,   7, 
                ALR0,   8, 
                ALR1,   8
            }
        
        Method (ECSB, 7, NotSerialized)
        {
              If (_OSI("Darwin")) {
            Store (Package (0x05)
                {
                    0x11, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Buffer (0x20){}
                }, Local1)
            If (LGreater (Arg0, One))
            {
                Return (Local1)
            }

            If (ECAV ())
            {
                Acquire (MUEC, 0xFFFF)
                If (LEqual (Arg0, Zero))
                {
                    Store (PRTC, Local0)
                }
                Else
                {
                    Store (PRT2, Local0)
                }

                Store (Zero, Local2)
                While (LNotEqual (Local0, Zero))
                {
                    Stall (0x0A)
                    Increment (Local2)
                    If (LGreater (Local2, 0x03E8))
                    {
                        Store (SBBY, Index (Local1, Zero))
                        Store (Zero, Local0)
                    }
                    ElseIf (LEqual (Arg0, Zero))
                    {
                        Store (PRTC, Local0)
                    }
                    Else
                    {
                        Store (PRT2, Local0)
                    }
                }

                If (LLessEqual (Local2, 0x03E8))
                {
                    If (LEqual (Arg0, Zero))
                    {
                        Store (Arg2, ADDR)
                        Store (Arg3, CMDB)
                        If (LOr (LEqual (Arg1, 0x0A), LEqual (Arg1, 0x0B)))
                        {
                            Store (DerefOf (Index (Arg6, Zero)), BCNT)
                            //Store (DerefOf (Index (Arg6, One)), BDAT)
                            WECB(0x1c, 256, DerefOf (Index (Arg6, One)))
                        }
                        Else
                        {
                            Store (Arg4, DAT0)
                            Store (Arg5, DAT1)
                        }

                        Store (Arg1, PRTC)
                    }
                    Else
                    {
                        Store (Arg2, ADD2)
                        Store (Arg3, CMD2)
                        If (LOr (LEqual (Arg1, 0x0A), LEqual (Arg1, 0x0B)))
                        {
                            Store (DerefOf (Index (Arg6, Zero)), BCN2)
                            //Store (DerefOf (Index (Arg6, One)), BDA2)
                            WECB(0x44,256, DerefOf (Index (Arg6, One)))
                        }
                        Else
                        {
                            Store (Arg4, DA20)
                            Store (Arg5, DA21)
                        }

                        Store (Arg1, PRT2)
                    }

                    Store (0x7F, Local0)
                    If (LEqual (Arg0, Zero))
                    {
                        While (PRTC)
                        {
                            Sleep (One)
                            Decrement (Local0)
                        }
                    }
                    Else
                    {
                        While (PRT2)
                        {
                            Sleep (One)
                            Decrement (Local0)
                        }
                    }

                    If (Local0)
                    {
                        If (LEqual (Arg0, Zero))
                        {
                            Store (SSTS, Local0)
                            Store (DAT0, Index (Local1, One))
                            Store (DAT1, Index (Local1, 0x02))
                            Store (BCNT, Index (Local1, 0x03))
                            //Store (BDAT, Index (Local1, 0x04))
                            Store(RECB(0x1c, 256), Index (Local1, 0x04))
                        }
                        Else
                        {
                            Store (SST2, Local0)
                            Store (DA20, Index (Local1, One))
                            Store (DA21, Index (Local1, 0x02))
                            Store (BCN2, Index (Local1, 0x03))
                            //Store (BDA2, Index (Local1, 0x04))
                            Store(RECB(0x4c,256), Index (Local1, 0x04))
                        }

                        And (Local0, 0x1F, Local0)
                        If (Local0)
                        {
                            Add (Local0, 0x10, Local0)
                        }

                        Store (Local0, Index (Local1, Zero))
                    }
                    Else
                    {
                        Store (0x10, Index (Local1, Zero))
                    }
                }

                Release (MUEC)
            }

            Return (Local1) }
        else {
            return XCSB(Arg0, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
            }
        }

                                               
    }
}

