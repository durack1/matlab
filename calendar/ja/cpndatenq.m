% CPNDATENQ �m�藘�t�ɑ΂��鎟��̏��N�[�|����
%
% ���̊֐��́ANUMBONDS �̊m�藘�t�̎��񏀃N�[�|�������o�͂��܂��B
%�u���񏀃N�[�|�����v�Ƃ́A��1��̃N�[�|�������w�肳��Ă��Ȃ��Ƃ���
% �Z�肳�ꂽ����N�[�|�����̂��Ƃł��B���̊֐��́A���̍ŏ��A�܂���
% �Ō�̃N�[�|���x���܂ł̊��Ԃ̒��Z�Ɋւ�炸�A���񏀃N�[�|�������o�͂��܂��B
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity)
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity, Period, Basis, 
%                                     EndMonthRule, IssueDate, FirstCouponDate,
%                                     LastCouponDate)
% ����: 
%     Settle    - ���ϓ�
%     Maturity  - ������
%
% �I�v�V�����̓���:
%     Period - �N������̃N�[�|���x����; �f�t�H���g�� 2 (���N����)
%     Basis - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%     EndMonthRule - �����K��; �f�t�H���g�� 1 (�����K���͗L��)
%     IssueDate - ���̔��s��
%     FirstCouponDate - �ŏ��̃N�[�|���x����.
%     LastCouponDate - �Ō�̃N�[�|���x����
%
% �o��: 
%     NextQuasiCouponDate - ���ϓ��ȍ~�̎��ۂ̎��񏀃N�[�|�����̓��t����Ȃ�
%       NUMBONDS�s1��̃x�N�g���ł��B���ϓ����N�[�|�����Ɠ���̏ꍇ�A����
%       �֐��͌��ϓ����o�͂��܂���B����ɁA�����Ɍ��ϓ��ȍ~�̎��ۂ�
%       �N�[�|�������o�͂��܂��B
%
% ����:
%     �K�{�̈����́ANUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�܂���
%     �X�J�������łȂ���΂Ȃ�܂���B�I�v�V�����̈�����NUMBONDS�s1��A
%     �܂��́A1�sNUMBONDS�� �̃x�N�g���A�X�J���A�܂��͋�s��łȂ���΂Ȃ��
%     ����B�l�̎w��̂Ȃ����͂ɂ� NaN ����̓x�N�g���Ƃ��Đݒ肵�Ă��������B
%     ���t�́A�V���A�����t�ԍ��A�܂��͓��t������ł��B
%
%     ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%     'help ftb' + ������ (���Ƃ��΁ASettle (���ϓ�) �Ɋւ���w���v�́A
%     "help ftbSettle") �ƃ^�C�v���ĎQ�Ƃł��܂��B
%
% �Q�l CPNDATEN, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.     

% Copyright 1995-2006 The MathWorks, Inc.
