%CFAMOUNTS  ポートフォリオの債券から発生するキャッシュフローと時間の対応付け
%
%   CFAMOUNTS は、キャッシュフローとキャッシュフローの日付、クーポンの割引に
%   適した時間を返します。
%
%  [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = cfamounts(...
%       CouponRate, Settle, Maturity)
%
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = cfamounts(...
%       CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
%       IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face)
%
%
%   入力: [スカラまたは NBONDS x 1 のベクトル]
%     CouponRate - 小数表示のクーポンレート。割引債なら 0 となります。
%
%     Settle     - 決済日。
%
%     Maturity   - 満期日。
%
%   オプションの入力: [スカラまたは NBONDS x 1 のベクトル]
%     Period         - 年当たりのクーポン回数。デフォルトは 2 (半年払い)。
%
%     Basis          - ポートフォリオの債券に関する日数計算方式。
%                      利用可能な値は次のとおりです。
%                      0 - actual/actual (デフォルト)
%                      1 - 30/360 SIA
%                      2 - actual/360
%                      3 - actual/365
%                      4 - 30/360 PSA
%                      5 - 30/360 ISDA
%                      6 - 30E /360
%                      7 - actual/365 日本
%                      8 - actual/actual ISMA
%                      9 - actual/360 ISMA
%                     10 - actual/365 ISMA
%                     11 - 30/360 ISMA
%                     12 - actual/365 ISDA
%
%    EndMonthRule    - 月末規則。デフォルトは 1 (月末規則有効)。
%
%    IssueDate       - 発行日
%
%    FirstCouponDate - 最初のクーポン支払日。
%
%    LastCouponDate  - 最後のクーポン支払日。
%
%    StartDate       - 開始日 (将来利用するための引数)。
%
%    Face            - 額面価格。デフォルトは 100 です。
%
%   出力: 出力は NBONDS 行 NCFS 列の行列です。それぞれの行は、該当債券に対する
%         キャッシュフローを示しています。桁が短い行は、NaN による桁揃えが行われます。
%
%      CFlowAmounts  - キャッシュフローの総額。それぞれの行ベクトルの最初の
%                      要素は決済日に支払われるべき (負の) 経過利子です。
%                      経過利子が支払われない場合は、最初の列は 0 となります。
%
%      CFlowDates    -  キャッシュフロー日付を示すシリアル番号日付です。
%                       少なくとも 2 つの列 (決済日、満期日) は常に存在します。
%
%      TFactors      - 価格/利回り換算に用いる時間係数。
%                      端数の SIA 半年価格／利回り換算に用いる時間係数: 
%                      DiscountFactor = (1 + Yield/2).^(-TFactor)
%                      時間係数は半年クーポン期間が単位となって算定されます。
%
%      CFlowFlags    - 利払いのタイプを示すキャッシュフローフラグです。
%                      "help ftbcflowflags" と入力すると、これらのフラグに
%                      関する詳細な説明を見ることができます。
%
%  参考文献:  Standard Securities Calculations Methods: Fixed Income
%              Securities Formulas for Analytic Measures, SIA Vol 2, Jan
%              Mayle, (c) 1994
%
%  参考 CFDATES, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%       CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.


%  Copyright 1995-2008 The MathWorks, Inc.
