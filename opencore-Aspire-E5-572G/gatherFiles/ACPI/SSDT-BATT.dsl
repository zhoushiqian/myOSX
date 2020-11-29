/*

 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "BATT", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC0, DeviceObj)
    	External (_SB_.PCI0.LPCB.EC0.FAMX, MutexObj)
    	External (_SB_.PCI0.LPCB.EC0.XANG, MethodObj)
    	External (_SB_.PCI0.LPCB.EC0.XANW, MethodObj)
    	External (_SB_.PCI0.LPCB.EC0.XFUN, MethodObj)
    External (_SB_.PCI0.LPCB.EC0.CTSL, PkgObj)
    External (_SB_.PCI0.LPCB.EC0.CFMX, MutexObj)
    External (SMID, FieldUnitObj)
    External (SFNO, FieldUnitObj)
    External (BFDT, FieldUnitObj)
    External (SMIC, FieldUnitObj)
    External (CAVR, FieldUnitObj)
    External (STDT, FieldUnitObj)
    External (P80H, FieldUnitObj)
    External (SMAD, FieldUnitObj)
    External (SMCM, FieldUnitObj)
    External (SMPR, FieldUnitObj)
    External (SMST, FieldUnitObj)
    External (BCNT, FieldUnitObj)
    External (ERBD, FieldUnitObj)



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
        
            OperationRegion (XCRM, EmbeddedControl, Zero, 0xFF)
            Field (XCRM, ByteAcc, Lock, Preserve)
            {
                Offset (0x5D), 
                ERI0,   8,
                ERI1,   8,
            }
            
                    
            Method (FANG, 1, NotSerialized)
            {
                If (_OSI("Darwin")) {
                
                    Acquire (FAMX, 0xFFFF)
                    W16B(ERI0,ERI1, Arg0)
                    Store (ERBD, Local0)
                    Release (FAMX)
                    Return (Local0)
                } else {
                    return(XANG(Arg0))
                }
            }
        
            Method (FANW, 2, NotSerialized)
            {
                If (_OSI("Darwin")) {
                    Acquire (FAMX, 0xFFFF)
                    W16B(ERI0,ERI1, Arg0)
                    Store (Arg1, ERBD)
                    Release (FAMX)
                    Return (Arg1)
                }else {
                    return(XANW(Arg0))
                }
            }
            

            
            Method (CFUN, 4, Serialized)
            {
                If (_OSI("Darwin")) {
                 Name (ESRC, 0x05)
                If (LNotEqual (Match (CTSL, MEQ, DerefOf (Index (Arg0, Zero)), MTR, Zero, Zero), Ones))
                {
                    Acquire (CFMX, 0xFFFF)
                    Store (Arg0, SMID)
                    Store (Arg1, SFNO)
                    Store (Arg2, BFDT)
                    Store (0xCE, SMIC)
                    Release (CFMX)
                }
                ElseIf (LEqual (DerefOf (Index (Arg0, Zero)), 0x10))
                {
                    If (LEqual (DerefOf (Index (Arg1, Zero)), One))
                    {
                        CreateByteField (Arg2, Zero, CAPV)
                        Store (CAPV, CAVR)
                        Store (One, STDT)
                    }
                    ElseIf (LEqual (DerefOf (Index (Arg1, Zero)), 0x02))
                    {
                        Store (Buffer (0x80){}, Local0)
                        CreateByteField (Local0, Zero, BFD0)
                        Store (0x11, BFD0)
                        Store (One, STDT)
                        Store (Local0, BFDT)
                    }
                    Else
                    {
                        Store (Zero, STDT)
                    }
                }
                ElseIf (LEqual (DerefOf (Index (Arg0, Zero)), 0x27))
                {
                    If (LEqual (DerefOf (Index (Arg1, Zero)), One))
                    {
                        Store (Zero, STDT)
                        Store (Zero, BFDT)
                    }
                    ElseIf (LEqual (DerefOf (Index (Arg1, Zero)), 0x02))
                    {
                        Store (Zero, STDT)
                        Store (Zero, BFDT)
                        Store (Zero, BFDT)
                        Store (One, STDT)
                    }
                    Else
                    {
                        Store (Zero, STDT)
                    }
                }
                ElseIf (LEqual (DerefOf (Index (Arg0, Zero)), 0x18))
                {
                    Acquire (CFMX, 0xFFFF)
                    If (LEqual (DerefOf (Index (Arg1, Zero)), 0x02))
                    {
                        
                        WECB(0x64,256,Zero)
                        Store (DerefOf (Index (Arg2, One)), SMAD)
                        Store (DerefOf (Index (Arg2, 0x02)), SMCM)
                        Store (DerefOf (Index (Arg2, Zero)), SMPR)
                        While (LAnd (Not (LEqual (ESRC, Zero)), Not (LEqual (And (SMST, 0x80), 0x80))))
                        {
                            Sleep (0x14)
                            Subtract (ESRC, One, ESRC)
                        }

                        Store (SMST, Local2)
                        If (LEqual (And (Local2, 0x80), 0x80))
                        {
                            Store (Buffer (0x80){}, Local1)
                            Store (Local2, Index (Local1, Zero))
                            If (LEqual (Local2, 0x80))
                            {
                                Store (0xC4, P80H)
                                Store (BCNT, Index (Local1, One))
                                
                                Store(RECB(0x64,256), Local3)
                                Store (DerefOf (Index (Local3, Zero)), Index (Local1, 0x02))
                                Store (DerefOf (Index (Local3, One)), Index (Local1, 0x03))
                                Store (DerefOf (Index (Local3, 0x02)), Index (Local1, 0x04))
                                Store (DerefOf (Index (Local3, 0x03)), Index (Local1, 0x05))
                                Store (DerefOf (Index (Local3, 0x04)), Index (Local1, 0x06))
                                Store (DerefOf (Index (Local3, 0x05)), Index (Local1, 0x07))
                                Store (DerefOf (Index (Local3, 0x06)), Index (Local1, 0x08))
                                Store (DerefOf (Index (Local3, 0x07)), Index (Local1, 0x09))
                                Store (DerefOf (Index (Local3, 0x08)), Index (Local1, 0x0A))
                                Store (DerefOf (Index (Local3, 0x09)), Index (Local1, 0x0B))
                                Store (DerefOf (Index (Local3, 0x0A)), Index (Local1, 0x0C))
                                Store (DerefOf (Index (Local3, 0x0B)), Index (Local1, 0x0D))
                                Store (DerefOf (Index (Local3, 0x0C)), Index (Local1, 0x0E))
                                Store (DerefOf (Index (Local3, 0x0D)), Index (Local1, 0x0F))
                                Store (DerefOf (Index (Local3, 0x0E)), Index (Local1, 0x10))
                                Store (DerefOf (Index (Local3, 0x0F)), Index (Local1, 0x11))
                                Store (DerefOf (Index (Local3, 0x10)), Index (Local1, 0x12))
                                Store (DerefOf (Index (Local3, 0x11)), Index (Local1, 0x13))
                                Store (DerefOf (Index (Local3, 0x12)), Index (Local1, 0x14))
                                Store (DerefOf (Index (Local3, 0x13)), Index (Local1, 0x15))
                                Store (DerefOf (Index (Local3, 0x14)), Index (Local1, 0x16))
                                Store (DerefOf (Index (Local3, 0x15)), Index (Local1, 0x17))
                                Store (DerefOf (Index (Local3, 0x16)), Index (Local1, 0x18))
                                Store (DerefOf (Index (Local3, 0x17)), Index (Local1, 0x19))
                                Store (DerefOf (Index (Local3, 0x18)), Index (Local1, 0x1A))
                                Store (DerefOf (Index (Local3, 0x19)), Index (Local1, 0x1B))
                                Store (DerefOf (Index (Local3, 0x1A)), Index (Local1, 0x1C))
                                Store (DerefOf (Index (Local3, 0x1B)), Index (Local1, 0x1D))
                                Store (DerefOf (Index (Local3, 0x1C)), Index (Local1, 0x1E))
                                Store (DerefOf (Index (Local3, 0x1D)), Index (Local1, 0x1F))
                                Store (DerefOf (Index (Local3, 0x1E)), Index (Local1, 0x20))
                                Store (DerefOf (Index (Local3, 0x1F)), Index (Local1, 0x21))
                            }

                            Store (Local1, BFDT)
                            Store (One, STDT)
                        }
                        Else
                        {
                            Store (0xC5, P80H)
                            Store (Zero, STDT)
                        }
                    }
                    Else
                    {
                        Store (0xC6, P80H)
                        Store (Zero, STDT)
                    }

                    Release (CFMX)
                }
                Else
                {
                    Store (Zero, STDT)
                }
                   
                } else {
                    return (XFUN (Arg0,Arg1,Arg2,Arg3))
                }
            }            
    }



}

