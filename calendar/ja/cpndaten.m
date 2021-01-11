% CPNDATEN 確定利付債の次回のクーポン支払日
%
% この関数は、NUMBONDS の確定利付債券のある設定について、次回の実際の
% クーポンを出力します。この関数は債券の最初、または最後のクーポン支払
% までの期間の長さに関わらず、次回のクーポン日を出力します。
% ゼロクーポン債の場合、この関数は満期日を出力します。
%
%   NextCouponDate = cpndaten(Settle, Maturity)
%
%   NextCouponDate = cpndaten(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
% 入力: 
%     Settle    - 決済日
%     Maturity  - 満期日
%
% オプションの入力:
%     Period - 年当たりのクーポン支払回数; デフォルトは 2 (半年払い)
%     Basis - 日付カウント基準; デフォルトは 0 (actual/actual)
%     EndMonthRule - 月末規則; デフォルトは 1 (月末規則は有効)
%     IssueDate - 債券の発行日
%     FirstCouponDate - 最初のクーポン支払日
%     LastCouponDate - 最後のクーポン支払日
%
% 出力: 
%     NextCouponDate - 決済日以降の実際の次回クーポン日の日付からなる
%       NUMBONDS行1列 のベクトルです。決済日がクーポン日と同一の場合、
%       この関数は決済日を出力しません。その代わりに、厳密に決済日以降の
%       実際のクーポン日を出力します (ただし、満期日以降の場合を除く)。
%       そのため、この関数は常に実際の満期日と次回クーポン支払日のうち、
%       より近いほうの日付を常に出力します。
%
% 注意:
%     必須の引数は、 NUMBONDS行1列、または1行NUMBONDS列のベクトル、または
%     スカラ引数でなければなりません。オプションの引数は、NUMBONDS行1列、
%     または、1行NUMBONDS 列のベクトル、スカラ、または空行列でなければなり
%     ません。値の指定のない入力には NaN を入力ベクトルとして設定して
%     ください。日付は、シリアル日付番号、または日付文字列です。
%
%     それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%     'help ftb' + 引数名 (たとえば、Settle(決済日)に関するヘルプは、
%     "help ftbSettle"）とタイプして参照できます。
%
% 参考 CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.

% Copyright 1995-2006 The MathWorks, Inc.
