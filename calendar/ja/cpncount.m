% CPNCOUNT �������܂ł̃N�[�|���̎x�����̉�
%
% ���̊֐��́ANBONDS �̊m�藘�t�ɂ��āA�������܂łɎc���ꂽ�N�[�|��
% �x�����̉񐔂��o�͂��܂��B
% 
%   NumCouponsRemaining = cpncount(Settle, Maturity)
%
%   NumCouponsRemaining = cpncount(Settle, Maturity, Period, Basis, ...
%          EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%          StartDate)
%
%   ����: ���� (�K�{) �́ANBONDS�s1��̃x�N�g���A�܂��̓X�J�������ł��B�I�v�V������
%     ���͂́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B�܂��A�������X�g�̌㔼�̃I�v�V����
%     ���͂́A�A������ꍇ�A�ȗ����邱�Ƃ��ł��܂��B�I�v�V�����̓��͂̂����ꂩ�� 
%     NaN ��ݒ肷��ƁA�f�t�H���g�l���ݒ肳��܂��B���t�����́A�V���A�����t�ԍ��A
%     �܂��͓��t������ł��BSIA �m�藘�t�̈����̏ڍׂ�����ɂ́A'help ftb' ��
%     �^�C�v���Ă��������B�������̈����Ɋւ���ڍׁA���Ƃ��΁ASettle �Ɋւ���
%     �w���v�́A"help ftbSettle" �Ɠ��͂���ΎQ�Ƃł��܂��B
%
%     Settle (�K�{)  - ���ϓ�
%     Maturity (�K�{)- ������
%   
% �I�v�V�����̓���:
%     Period - �N������̃N�[�|���x����; �f�t�H���g�� 2 (���N����)
%     Basis  - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%     EndMonthRule - �����K��; �f�t�H���g�� 1 (�����K���͗L��)
%     IssueDate - ���s��
%     FirstCouponDate - �ŏ��̃N�[�|���x����
%     LastCouponDate - �Ō�̃N�[�|���x����
%     StartDate - (�������p���邽�߂̈���)
%
%
% �o��: 
%     NumCouponsRemaining - ���ϓ�����Ɏx������N�[�|���̉񐔂����� 
%                           NBONDS�s1��̃x�N�g���ł��B���ϓ��Ɏx������
%                           �N�[�|���y�ь��ϓ����O�Ɏx����ꂽ�N�[�|����
%                           ���Ă̓J�E���g����܂���B�A���A�������Ɏx����
%                           ���N�[�|���ɂ��Ă͏�ɃJ�E���g����܂��B
%
% �Q�l CPNCDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, 
%      CPNPERSZ, CFDATES, CFAMOUTNS, ACCRFRAC, CFTIMES.
 

% Copyright 1995-2006 The MathWorks, Inc.
