//+------------------------------------------------------------------+
//|                                                  SeasonTrend.mq5 |
//|                                                           Volder |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Volder"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window

#property indicator_buffers 4
#property indicator_plots   2
#property script_show_inputs

#property indicator_label1 "SeasonTrend"
#property indicator_label2 "Season%Trend"
#property indicator_color1 clrOrange
#property indicator_color2 clrDarkOrange
#property indicator_width1 2
#property indicator_width2 2

input ENUM_DRAW_TYPE styling1 = DRAW_HISTOGRAM;               //SeasonTrend
input ENUM_DRAW_TYPE styling2 = DRAW_HISTOGRAM;               //Season%Trend

input int period = 20;
input int shift = 0;
input ENUM_MA_METHOD ma_method = MODE_SMA;           //Тип сглаживания

int handle_sma;
int handle_ind;

struct DayOfYear {
   double value;
   int count;   
};

double      IndBuffer[];
DayOfYear   DOYBuffer[366];

double IndPersBuffer[];
double SmaBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, IndBuffer, INDICATOR_DATA);
   
   PlotIndexSetInteger(0, PLOT_DRAW_TYPE, styling1);

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
   if(prev_calculated == 0) {
      ArrayInitialize(IndBuffer, 0);
      for(int i = 0; i < ArraySize(DOYBuffer); ++i) {
         DOYBuffer[i].value = 0;
         DOYBuffer[i].count = 0;
      }
      
      MqlDateTime stm;
      int val;
      for(int i = 0; i < rates_total; ++i) {
         TimeToStruct(time[i], stm);
         val = close[i] - open[i];
         DOYBuffer[stm.day_of_year].value += val;
         DOYBuffer[stm.day_of_year].count += 1;
      }
      
      for(int i = 0; i < ArraySize(DOYBuffer); ++i)
         DOYBuffer[stm.day_of_year].value /= (double) DOYBuffer[stm.day_of_year].count;
         
      for(int i = 0; i < rates_total; ++i) {
         TimeToStruct(time[i], stm);
         IndBuffer[i] = DOYBuffer[stm.day_of_year].value;
      }
   
   }


   return(rates_total);
}
//+------------------------------------------------------------------+
