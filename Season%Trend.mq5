//+------------------------------------------------------------------+
//|                                                 Season%Trend.mq5 |
//|                                                           Volder |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Volder"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property script_show_inputs

#property indicator_buffers 2
#property indicator_plots   1
#property script_show_inputs

#property indicator_label1 "Season%Trend"
#property indicator_color1 clrOrange
#property indicator_width1 2

input ENUM_DRAW_TYPE styling1 = DRAW_HISTOGRAM;               //Season%Trend

input int period = 20;
input int shift = 0;
input ENUM_MA_METHOD ma_method = MODE_SMA;           // тип сглаживания

int handle_sma;
int handle_ind;

double IndBuffer[];
double SmaBuffer[];

int OnInit()
{
   SetIndexBuffer(0, SmaBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, IndBuffer, INDICATOR_DATA);
   
   PlotIndexSetInteger(0, PLOT_DRAW_TYPE, styling1);
   
   handle_ind = iCustom(NULL, 0, "MyIndicators\\SeasonTrend");
   handle_sma=iMA(NULL, PERIOD_CURRENT, period, shift, ma_method, handle_ind);
   
   

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int values_to_copy;
   int start = 0;
   
   if(prev_calculated == 0) {
      ArrayInitialize(SmaBuffer, 0);
      ArrayInitialize(IndBuffer, 0);
      values_to_copy = rates_total;
      
      
      CopyBuffer(handle_ind, 0, start, values_to_copy, IndBuffer);
      CopyBuffer(handle_sma, 0, start, values_to_copy, SmaBuffer);
   }


   return(rates_total);
}
//+------------------------------------------------------------------+
