#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function JOBNFS()
    Local aAreaIm  := GetArea()
        StartJob("u_JOBNFSA1",GetEnvServer(),.F.,"01")
        StartJob("u_JOBNFSA2",GetEnvServer(),.F.,"02")
        StartJob("u_JOBNFSA3",GetEnvServer(),.F.,"03")
        StartJob("u_JOBNFSA4",GetEnvServer(),.F.,"04")
        StartJob("u_JOBNFS05",GetEnvServer(),.F.,"05")

        StartJob("u_JOBNFS06",GetEnvServer(),.F.,"06")
        StartJob("u_JOBNFS07",GetEnvServer(),.F.,"07")
        StartJob("u_JOBNFS08",GetEnvServer(),.F.,"08")
        StartJob("u_JOBNFS09",GetEnvServer(),.F.,"09")
        StartJob("u_JOBNFS10",GetEnvServer(),.F.,"10")

        StartJob("u_JOBNFS11",GetEnvServer(),.F.,"11")
        StartJob("u_JOBNFS12",GetEnvServer(),.F.,"12")
        StartJob("u_JOBNFS13",GetEnvServer(),.F.,"13")
        StartJob("u_JOBNFS14",GetEnvServer(),.F.,"14")
        StartJob("u_JOBNFS15",GetEnvServer(),.F.,"15")

        StartJob("u_JOBNFS16",GetEnvServer(),.F.,"16")
        StartJob("u_JOBNFS17",GetEnvServer(),.F.,"17")
        StartJob("u_JOBNFS18",GetEnvServer(),.F.,"18")
        StartJob("u_JOBNFS19",GetEnvServer(),.F.,"19")
        StartJob("u_JOBNFS20",GetEnvServer(),.F.,"20")

    RestArea(aAreaIm)
Return

