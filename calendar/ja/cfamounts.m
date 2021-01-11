%CFAMOUNTS  �|�[�g�t�H���I�̍����甭������L���b�V���t���[�Ǝ��Ԃ̑Ή��t��
%
%   CFAMOUNTS �́A�L���b�V���t���[�ƃL���b�V���t���[�̓��t�A�N�[�|���̊�����
%   �K�������Ԃ�Ԃ��܂��B
%
%  [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = cfamounts(...
%       CouponRate, Settle, Maturity)
%
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = cfamounts(...
%       CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
%       IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face)
%
%
%   ����: [�X�J���܂��� NBONDS x 1 �̃x�N�g��]
%     CouponRate - �����\���̃N�[�|�����[�g�B�����Ȃ� 0 �ƂȂ�܂��B
%
%     Settle     - ���ϓ��B
%
%     Maturity   - �������B
%
%   �I�v�V�����̓���: [�X�J���܂��� NBONDS x 1 �̃x�N�g��]
%     Period         - �N������̃N�[�|���񐔁B�f�t�H���g�� 2 (���N����)�B
%
%     Basis          - �|�[�g�t�H���I�̍��Ɋւ�������v�Z�����B
%                      ���p�\�Ȓl�͎��̂Ƃ���ł��B
%                      0 - actual/actual (�f�t�H���g)
%                      1 - 30/360 SIA
%                      2 - actual/360
%                      3 - actual/365
%                      4 - 30/360 PSA
%                      5 - 30/360 ISDA
%                      6 - 30E /360
%                      7 - actual/365 ���{
%                      8 - actual/actual ISMA
%                      9 - actual/360 ISMA
%                     10 - actual/365 ISMA
%                     11 - 30/360 ISMA
%                     12 - actual/365 ISDA
%
%    EndMonthRule    - �����K���B�f�t�H���g�� 1 (�����K���L��)�B
%
%    IssueDate       - ���s��
%
%    FirstCouponDate - �ŏ��̃N�[�|���x�����B
%
%    LastCouponDate  - �Ō�̃N�[�|���x�����B
%
%    StartDate       - �J�n�� (�������p���邽�߂̈���)�B
%
%    Face            - �z�ʉ��i�B�f�t�H���g�� 100 �ł��B
%
%   �o��: �o�͂� NBONDS �s NCFS ��̍s��ł��B���ꂼ��̍s�́A�Y�����ɑ΂���
%         �L���b�V���t���[�������Ă��܂��B�����Z���s�́ANaN �ɂ�錅�������s���܂��B
%
%      CFlowAmounts  - �L���b�V���t���[�̑��z�B���ꂼ��̍s�x�N�g���̍ŏ���
%                      �v�f�͌��ϓ��Ɏx������ׂ� (����) �o�ߗ��q�ł��B
%                      �o�ߗ��q���x�����Ȃ��ꍇ�́A�ŏ��̗�� 0 �ƂȂ�܂��B
%
%      CFlowDates    -  �L���b�V���t���[���t�������V���A���ԍ����t�ł��B
%                       ���Ȃ��Ƃ� 2 �̗� (���ϓ��A������) �͏�ɑ��݂��܂��B
%
%      TFactors      - ���i/����芷�Z�ɗp���鎞�ԌW���B
%                      �[���� SIA ���N���i�^����芷�Z�ɗp���鎞�ԌW��: 
%                      DiscountFactor = (1 + Yield/2).^(-TFactor)
%                      ���ԌW���͔��N�N�[�|�����Ԃ��P�ʂƂȂ��ĎZ�肳��܂��B
%
%      CFlowFlags    - �������̃^�C�v�������L���b�V���t���[�t���O�ł��B
%                      "help ftbcflowflags" �Ɠ��͂���ƁA�����̃t���O��
%                      �ւ���ڍׂȐ��������邱�Ƃ��ł��܂��B
%
%  �Q�l����:  Standard Securities Calculations Methods: Fixed Income
%              Securities Formulas for Analytic Measures, SIA Vol 2, Jan
%              Mayle, (c) 1994
%
%  �Q�l CFDATES, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%       CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.


%  Copyright 1995-2008 The MathWorks, Inc.
