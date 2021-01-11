% CPNDATEPQ 確定利付債の前回の準クーポン日
%
% この関数は、NUMBONDS の確定利付債の前回準クーポン日を出力します。
% 前回準クーポン日は、確定利付債について、標準クーポン期間の長さを
% 決定します。ただし、前回準クーポン日が必ずしも実際のクーポン支払日と
% 一致するとは限りません。この関数は、最初、または最後のクーポン支払
% までの期間の長短に関わらず、前回準クーポン日を出力します。
%
%   PreviousQuasiCouponDate = cpndatepq(Settle, Maturity)
%
%   PreviousQuasiCouponDate = cpndatepq(Settle, Maturity, Period, Basis, 
%                                   EndMonthRule, IssueDate, FirstCouponDate,
%                                   LastCouponDate)
% 入力: 
%     Settle - 決済日
%     Maturity - 満期日
%
% オプションの入力:
%     Period - 年当たりのクーポン回数; デフォルトは 2 (半年払い)
%     Basis - 日数のカウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 発行日
%     FirstCouponDate - 最初のクーポン日
%     LastCouponDate - 最後のクーポン日
%
% 出力: 
%     PreviousQuasiCouponDate - 決済日以前の前回準クーポン日からなる
%     NUMBONDS行1列のベクトルです。決済日がクーポン日と同一の場合、
%     この関数は決済日を出力します。
%
% 注意:
%     必須の引数は、NUMBONDS行1列、または 1行NUMBONDS列のベクトル、または
%     スカラ引数でなければなりません。オプションの引数は、NUMBONDS行1列、
%     または、1行NUMBONDS列のベクトル、スカラ、または空行列でなければ
%     なりません。値の指定のない入力には NaN を入力ベクトルとして設定して
%     ください。日付はシリアル日付番号、または日付文字列です。
%  
%     それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%     'help ftb' + 引数名 (たとえば、Settle (決済日) に関するヘルプは、
%     "help ftbSettle") とタイプして得られます。
%
% 参考 CPNDATEN, CPNDATENQ, CPNDATEP, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.     


% Copyright 1995-2006 The MathWorks, Inc.
