% CPNCOUNT 満期日までのクーポンの支払いの回数
%
% この関数は、NBONDS の確定利付債について、満期日までに残されたクーポン
% 支払いの回数を出力します。
% 
%   NumCouponsRemaining = cpncount(Settle, Maturity)
%
%   NumCouponsRemaining = cpncount(Settle, Maturity, Period, Basis, ...
%          EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%          StartDate)
%
%   入力: 入力 (必須) は、NBONDS行1列のベクトル、またはスカラ引数です。オプションの
%     入力は、空行列によって省略することもできます。また、引数リストの後半のオプション
%     入力は、連続する場合、省略することもできます。オプションの入力のいずれかに 
%     NaN を設定すると、デフォルト値が設定されます。日付引数は、シリアル日付番号、
%     または日付文字列です。SIA 確定利付債の引数の詳細を見るには、'help ftb' と
%     タイプしてください。ある特定の引数に関する詳細、たとえば、Settle に関する
%     ヘルプは、"help ftbSettle" と入力すれば参照できます。
%
%     Settle (必須)  - 決済日
%     Maturity (必須)- 満期日
%   
% オプションの入力:
%     Period - 年当たりのクーポン支払回数; デフォルトは 2 (半年払い)
%     Basis  - 日数のカウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 発行日
%     FirstCouponDate - 最初のクーポン支払日
%     LastCouponDate - 最後のクーポン支払日
%     StartDate - (将来利用するための引数)
%
%
% 出力: 
%     NumCouponsRemaining - 決済日より後に支払われるクーポンの回数を示す 
%                           NBONDS行1列のベクトルです。決済日に支払われる
%                           クーポン及び決済日より前に支払われたクーポンに
%                           ついてはカウントされません。但し、満期日に支払わ
%                           れるクーポンについては常にカウントされます。
%
% 参考 CPNCDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, 
%      CPNPERSZ, CFDATES, CFAMOUTNS, ACCRFRAC, CFTIMES.
 

% Copyright 1995-2006 The MathWorks, Inc.
