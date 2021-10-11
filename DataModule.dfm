object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 263
  Width = 439
  object DB_nimbus: TIBDatabase
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = IBTran
    Left = 48
    Top = 8
  end
  object IBEvents1: TIBEvents
    AutoRegister = False
    Database = DB_nimbus
    Registered = False
    OnEventAlert = IBEvents1EventAlert
    Left = 264
    Top = 184
  end
  object IBTran: TIBTransaction
    DefaultDatabase = DB_nimbus
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    AutoStopAction = saCommit
    Left = 8
    Top = 8
  end
  object OnlineTimer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = OnlineTimerTimer
    Left = 358
    Top = 8
  end
  object IB_Post: TIBStoredProc
    Database = DB_nimbus
    Transaction = IBTran_Write
    StoredProcName = 'IB_POST'
    Left = 8
    Top = 72
    ParamData = <
      item
        DataType = ftString
        Name = 'IN_EVENT'
        ParamType = ptInput
      end>
  end
  object User_Reg: TIBStoredProc
    Database = DB_nimbus
    Transaction = IBTran_Write
    StoredProcName = 'USER_REG'
    Left = 56
    Top = 72
    ParamData = <
      item
        DataType = ftTime
        Name = 'AWAY1'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'USER1'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'COMP1'
        ParamType = ptInput
      end>
  end
  object Query_UserID: TIBQuery
    Database = DB_nimbus
    Transaction = IBTran
    SQL.Strings = (
      'select ID from USERS Where USERNAME = :UserName_in')
    Left = 360
    Top = 56
    ParamData = <
      item
        DataType = ftString
        Name = 'UserName_in'
        ParamType = ptInput
        Value = '0'
      end>
    object Query_UserIDID: TIntegerField
      FieldName = 'ID'
      Origin = '"USERS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object Query_ReadMSG: TIBQuery
    Database = DB_nimbus
    Transaction = IBTran
    SQL.Strings = (
      
        'select ID, DNOW, FROM1, TO1, COMMAND,READ1, TXT, BLOB1 from AMES' +
        'SAGE where to1 = :to1_in and read1 < :read1_in;')
    Left = 264
    Top = 56
    ParamData = <
      item
        DataType = ftInteger
        Name = 'to1_in'
        ParamType = ptInput
        Value = 0
      end
      item
        DataType = ftUnknown
        Name = 'read1_in'
        ParamType = ptUnknown
      end>
    object IntegerField1: TIntegerField
      FieldName = 'ID'
      Origin = '"USERS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object Query_ReadMSGCOMMAND: TIBStringField
      FieldName = 'COMMAND'
      Origin = '"AMESSAGE"."COMMAND"'
      Size = 10
    end
    object Query_ReadMSGDNOW: TDateTimeField
      FieldName = 'DNOW'
      Origin = '"AMESSAGE"."DNOW"'
    end
    object Query_ReadMSGFROM1: TIntegerField
      FieldName = 'FROM1'
      Origin = '"AMESSAGE"."FROM1"'
      Required = True
    end
    object Query_ReadMSGTO1: TIntegerField
      FieldName = 'TO1'
      Origin = '"AMESSAGE"."TO1"'
      Required = True
    end
    object Query_ReadMSGTXT: TIBStringField
      FieldName = 'TXT'
      Origin = '"AMESSAGE"."TXT"'
      Size = 50
    end
    object Query_ReadMSGBLOB1: TMemoField
      FieldName = 'BLOB1'
      Origin = '"AMESSAGE"."BLOB1"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object Query_ReadMSGREAD1: TSmallintField
      FieldName = 'READ1'
      Origin = '"AMESSAGE"."READ1"'
    end
  end
  object Query_UserName: TIBQuery
    Database = DB_nimbus
    Transaction = IBTran
    SQL.Strings = (
      'select USERNAME from USERS Where ID = :id_in')
    Left = 360
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id_in'
        ParamType = ptUnknown
      end>
    object Query_UserNameUSERNAME: TIBStringField
      FieldName = 'USERNAME'
      Origin = '"USERS"."USERNAME"'
      Size = 10
    end
  end
  object User_msg: TIBStoredProc
    Database = DB_nimbus
    Transaction = IBTran_Write
    StoredProcName = 'USER_MSG'
    Left = 16
    Top = 120
    ParamData = <
      item
        DataType = ftInteger
        Name = 'FROM_IN'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'TO_IN'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'COMMAND_IN'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'TXT_IN'
        ParamType = ptInput
      end
      item
        DataType = ftBlob
        Name = 'BLOB1_IN'
        ParamType = ptInput
      end>
  end
  object Query_Custom: TIBQuery
    Database = DB_nimbus
    Transaction = IBTran_Write
    SQL.Strings = (
      '')
    Left = 256
    Top = 104
    object IntegerField2: TIntegerField
      FieldName = 'ID'
      Origin = '"USERS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IBStringField1: TIBStringField
      FieldName = 'COMMAND'
      Origin = '"AMESSAGE"."COMMAND"'
      Size = 10
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'DNOW'
      Origin = '"AMESSAGE"."DNOW"'
    end
    object IntegerField3: TIntegerField
      FieldName = 'FROM1'
      Origin = '"AMESSAGE"."FROM1"'
      Required = True
    end
    object IntegerField4: TIntegerField
      FieldName = 'TO1'
      Origin = '"AMESSAGE"."TO1"'
      Required = True
    end
    object IBStringField2: TIBStringField
      FieldName = 'TXT'
      Origin = '"AMESSAGE"."TXT"'
      Size = 50
    end
    object MemoField1: TMemoField
      FieldName = 'BLOB1'
      Origin = '"AMESSAGE"."BLOB1"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object DBConnectTimer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = DBConnectTimerTimer
    Left = 264
    Top = 8
  end
  object IBTran_Write: TIBTransaction
    DefaultDatabase = DB_nimbus
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommit
    Left = 112
    Top = 8
  end
  object User_ping: TIBStoredProc
    Database = DB_nimbus
    Transaction = IBTran_Write
    StoredProcName = 'USER_PING'
    Left = 104
    Top = 72
    ParamData = <
      item
        DataType = ftTime
        Name = 'AWAY1'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'USER1'
        ParamType = ptInput
      end>
  end
end
