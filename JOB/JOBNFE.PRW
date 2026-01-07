#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"


User Function JOBNFE()
    Local aAreaIm  := GetArea()
        StartJob("u_JOBNFEA1",GetEnvServer(),.F.,"01")
        StartJob("u_JOBNFEA2",GetEnvServer(),.F.,"02")
        StartJob("u_JOBNFEA3",GetEnvServer(),.F.,"03")
        StartJob("u_JOBNFEA4",GetEnvServer(),.F.,"04")
        StartJob("u_JOBNFE05",GetEnvServer(),.F.,"05")

        StartJob("u_JOBNFE06",GetEnvServer(),.F.,"06")
        StartJob("u_JOBNFE07",GetEnvServer(),.F.,"07")
        StartJob("u_JOBNFE08",GetEnvServer(),.F.,"08")
        StartJob("u_JOBNFE09",GetEnvServer(),.F.,"09")
        StartJob("u_JOBNFE10",GetEnvServer(),.F.,"10")


        StartJob("u_JOBNFE11",GetEnvServer(),.F.,"11")
        StartJob("u_JOBNFE12",GetEnvServer(),.F.,"12")
        StartJob("u_JOBNFE13",GetEnvServer(),.F.,"13")
        StartJob("u_JOBNFE14",GetEnvServer(),.F.,"14")
        StartJob("u_JOBNFE15",GetEnvServer(),.F.,"15")

        StartJob("u_JOBNFE16",GetEnvServer(),.F.,"16")
        StartJob("u_JOBNFE17",GetEnvServer(),.F.,"17")
        StartJob("u_JOBNFE18",GetEnvServer(),.F.,"18")
        StartJob("u_JOBNFE19",GetEnvServer(),.F.,"19")
        StartJob("u_JOBNFE20",GetEnvServer(),.F.,"20")

    RestArea(aAreaIm)
Return
