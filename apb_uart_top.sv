/////////////////////////////////////////////////////////////////
//                                                             //
//    ██████╗  ██████╗  █████╗                                 //
//    ██╔══██╗██╔═══██╗██╔══██╗                                //
//    ██████╔╝██║   ██║███████║                                //
//    ██╔══██╗██║   ██║██╔══██║                                //
//    ██║  ██║╚██████╔╝██║  ██║                                //
//    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝                                //
//          ██╗      ██████╗  ██████╗ ██╗ ██████╗              //
//          ██║     ██╔═══██╗██╔════╝ ██║██╔════╝              //
//          ██║     ██║   ██║██║  ███╗██║██║                   //
//          ██║     ██║   ██║██║   ██║██║██║                   //
//          ███████╗╚██████╔╝╚██████╔╝██║╚██████╗              //
//          ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝ ╚═════╝              //
//                                                             //
//    APB Mux - Allows multiple slaves on one APB bus          //
//      Generates slave PSELs                                  //
//      Decodes PREADY, PSLVERR, PRDATA                        //
//                                                             //
/////////////////////////////////////////////////////////////////
//                                                             //
//             Copyright (C) 2016-2017 ROA Logic BV            //
//             www.roalogic.com                                //
//                                                             //
//    Unless specifically agreed in writing, this software is  //
//  licensed under the RoaLogic Non-Commercial License         //
//  version-1.0 (the "License"), a copy of which is included   //
//  with this file or may be found on the RoaLogic website     //
//  http://www.roalogic.com. You may not use the file except   //
//  in compliance with the License.                            //
//                                                             //
//    THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY        //
//  EXPRESS OF IMPLIED WARRANTIES OF ANY KIND.                 //
//  See the License for permissions and limitations under the  //
//  License.                                                   //
//                                                             //
/////////////////////////////////////////////////////////////////

 
module apb_uart_top #(
  parameter  PADDR_SIZE = 12,
             PDATA_SIZE = 32,
             SLAVES     = 2
)
(
  //Common signals
  input                   PRESETn,
                          PCLK,

  //To/From APB master
  input                   MST_PSEL,
  input  [PADDR_SIZE-1:0] MST_PADDR, //MSBs of address bus
  input  [PDATA_SIZE-1:0] MST_PWDATA,
  input                   MST_PWRITE,
  input                   MST_PENABLE,
  output [PDATA_SIZE-1:0] MST_PRDATA,
  output                  MST_PREADY,
  output                  MST_PSLVERR,
  
  input                   mst_rx_i,
  output                  mst_tx_o,
  output                  mst_event_o
  )
  
 apb_mux
(
  .PCLK         ( PCLK                         )
  .PRESETn      ( PRESETn                      )
  .MST_PADDR    ( [PADDR_SIZE-1:0] MST_PADDR   )
  .MST_PWDATA   ( [PDATA_SIZE-1:0] MST_PWDATA  )
  .MST_PWRITE   ( MST_PWRITE                   )
  .MST_PSEL     ( MST_PSEL                     )
  . MST_PENABLE (  MST_PENABLE                 )
  .MST_PRDATA   ( [PDATA_SIZE-1:0] MST_PRDATA  )
  .MST_PREADY   ( MST_PREADY                   )
  .MST_PSLVERR  ( MST_PSLVERR                  )

  .mst_event_o  ( mst_rx_i                     )
  .mst_event_o  ( mst_tx_o                     )
  .mst_event_o  ( mst_event_o                  )
);
   
   //uart slaves
  apb_uart_sv apb_uart_sv_0
 (
  .CLK        ( PCLK                            )
  .RSTN       ( PRESETn                         )
  .PADDR      ( [PADDR_SIZE-1:0] slv_addr   [0] )
  .PWDATA     ( SLV_PWDATA                  [0] )
  .PWRITE     ( SLV_PWRITE                  [0] )
  .PSEL       ( SLV_PSEL                    [0] )
  .PENABLE    ( SLV_PENABLE                 [0] )
  .PRDATA     ( [PDATA_SIZE-1:0] SLV_PRDATA [0] )
  .PREADY     ( SLV_PREADY                  [0] )
  .PSLVERR    ( SLV_PSLVERR                 [0] )

  .rx_i       ( rx_i                        [0] )
  .tx_o       ( tx_o                        [0] )
  .event_o    ( event_o                     [0] )
);
 
   apb_uart_sv apb_uart_sv_1
 (
  .CLK        ( PCLK                            )
  .RSTN       ( PRESETn                         )
  .PADDR      ( [PADDR_SIZE-1:0] slv_addr   [1] )
  .PWDATA     ( SLV_PWDATA                  [1] )
  .PWRITE     ( SLV_PWRITE                  [1] )
  .PSEL       ( SLV_PSEL                    [1] )
  .PENABLE    ( SLV_PENABLE                 [1] )
  .PRDATA     ( [PDATA_SIZE-1:0] SLV_PRDATA [1] )
  .PREADY     ( SLV_PREADY                  [1] )
  .PSLVERR    ( SLV_PSLVERR                 [1] )

  .rx_i       ( slv_rx_i                    [1] )
  .tx_o       ( slv_tx_o                    [1] )
  .event_o    ( slv_event_o                 [1] )
);
  
