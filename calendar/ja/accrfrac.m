% ACCRFRAC 決済前のクーポン期間の端数
%
% この関数は、NBONDS の確定利付債に対して、決済日までに経過するクーポン
% 期間の端数を計算します。ここで計算された端数を指定された確定利付債の
% 定期キャッシュフローの名目額と掛け合わせることによって、当該債権に支払
% われる経過利子を算出することができます。この関数は、通常のクーポン期間
% をもつ債権や第1回目、または最終クーポン期間の長さが端数の債券の経過利子
% に対しても有効です。
%
%   Fraction = accrfrac(Settle, Maturity)
%   Fraction = accrfrac(Settle, Maturity, Period)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate, LastCouponDate)
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
%   Optional Inputs: Period, Basis, EndMonthRule, IssueDate,
%                    FirstCouponDate, LastCouponDate, StartDate
%
% 入力:
%   入力 (必須) は、NBONDS行1列のベクトル、またはスカラ引数です。オプションの
%   入力は、空行列によって省略することもできます。また、引数リストの後半のオプション
%   入力は、連続する場合、省略することもできます。オプションの入力のいずれかに 
%   NaN を設定すると、デフォルト値が設定されます。日付引数は、シリアル日付番号、
%   または日付文字列です。SIA 確定利付債の引数の詳細を見るには、'help ftb' と
%   タイプしてください。ある特定の引数に関する詳細、たとえば、Settle に関する
%   ヘルプは、"help ftbSettle" と入力すれば参照できます。
%
%       Settle          - 決済日
%       Maturity        - 満期日
%
% オプションの入力:
%       Period          - 年当たりのクーポン回数。デフォルトは 2 (半年払い)
%       Basis           - 日数カウント基準。デフォルトは 0 (Actual/Actual)
%       EndMonthRule    - 月末規則。デフォルトは 1 (月末規則有効)
%       IssueDate       - 発行日。経過利息の計算開始日。
%       FirstCouponDate - 最初のクーポン支払日。
%       LastCouponDate  - 最後にクーポン支払日。
%       StartDate       - (将来利用予定のための引数)
%
% 出力:
%       Fraction        - 経過利息の割合を表わすベクトル。
%
% 参考 CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%      CPNDAYSP, CPNPERSZ, CPNCOUNT, CFDATES.


% Copyright 1995-2006 The MathWorks, Inc.
