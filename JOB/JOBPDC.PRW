#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function JOBPDC()    //PEDIDO DE COMPRAS
    Local aAreaIm  := GetArea()
        StartJob("u_JOBPDC01",GetEnvServer(),.F.,"01")
        StartJob("u_JOBPDC02",GetEnvServer(),.F.,"02")
        StartJob("u_JOBPDC03",GetEnvServer(),.F.,"03")
        StartJob("u_JOBPDC04",GetEnvServer(),.F.,"04")
        StartJob("u_JOBPDC05",GetEnvServer(),.F.,"05")

        StartJob("u_JOBPDC06",GetEnvServer(),.F.,"06")
        StartJob("u_JOBPDC07",GetEnvServer(),.F.,"07")
        StartJob("u_JOBPDC08",GetEnvServer(),.F.,"08")
        StartJob("u_JOBPDC09",GetEnvServer(),.F.,"09")
        StartJob("u_JOBPDC00",GetEnvServer(),.F.,"10")

        StartJob("u_JOBPDC11",GetEnvServer(),.F.,"11")
        StartJob("u_JOBPDC12",GetEnvServer(),.F.,"12")
        StartJob("u_JOBPDC13",GetEnvServer(),.F.,"13")
        StartJob("u_JOBPDC14",GetEnvServer(),.F.,"14")
        StartJob("u_JOBPDC15",GetEnvServer(),.F.,"15")

        StartJob("u_JOBPDC16",GetEnvServer(),.F.,"16")
        StartJob("u_JOBPDC17",GetEnvServer(),.F.,"17")
        StartJob("u_JOBPDC18",GetEnvServer(),.F.,"18")
        StartJob("u_JOBPDC19",GetEnvServer(),.F.,"19")
        StartJob("u_JOBPDC20",GetEnvServer(),.F.,"20")

    RestArea(aAreaIm)
Return

