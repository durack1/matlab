% CPNDATEP 確定利付債の前回のクーポン日
%
% この関数は、NUMBONDS の確定利付債の前回のクーポン日を出力します。
% この関数は、最初、または最後のクーポンまでの期間の長短に関わらず、
% 債券の前回のクーポン日を出力します。ゼロクーポン債については、
% 満期日を出力します。
%
%   PreviousCouponDate = cpndatep(Settle, Maturity)
%
%   PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
% 入力: 
%     Settle - 決済日
%     Maturity - 満期日
%
% オプションの入力:
%     Period - 年当たりのクーポン支払回数; デフォルトは 2 (半年払い)
%     Basis - 日数のカウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 発行日
%     FirstCouponDate - 最初のクーポン日
%     LastCouponDate - 最後のクーポン日
%
% 出力: 
%     PreviousCouponDate - 決済日及びそれ以前に到来した実際の前回クーポン日
%     からなる NUMBONDS行1列 のベクトルです。決済日がクーポン日と同一の場合、
%     この関数は決済日を出力します。すなわち、厳密に決済日、またはそれ
%     以前の実際のクーポン日をこの関数は出力しますが、前回クーポン日が
%     発行日以前となる場合は (それが、たとえ利用可能であったとしても)
%     除外します。そのため、この関数は実際の発行日、または決済日を基準に
%     した前回クーポン日のいずれか近いほうの日付を出力します。
%
% 注意:
%     必須の引数は、NUMBONDS行1列、または、1行NUMBONDS列のベクトル、または
%     スカラでなければなりません。オプションの引数は、NUMBONDS行1列、または、
%     1行NUMBONDS列のベクトル、スカラ、または空行列でなければなりません。
%     値の指定のない入力には NaN を入力ベクトルとして設定してください。
%     日付は、シリアル日付番号、または日付文字列です。
%
%     それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%     'help ftb' + 引数名 (たとえば、Settle (決済日) に関するヘルプは、
%     "help ftbSettle") とタイプして得られます。
%
% 参考 CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


% Copyright 1995-2006 The MathWorks, Inc.
