% CPNDATEN �m�藘�t�̎���̃N�[�|���x����
%
% ���̊֐��́ANUMBONDS �̊m�藘�t���̂���ݒ�ɂ��āA����̎��ۂ�
% �N�[�|�����o�͂��܂��B���̊֐��͍��̍ŏ��A�܂��͍Ō�̃N�[�|���x��
% �܂ł̊��Ԃ̒����Ɋւ�炸�A����̃N�[�|�������o�͂��܂��B
% �[���N�[�|���̏ꍇ�A���̊֐��͖��������o�͂��܂��B
%
%   NextCouponDate = cpndaten(Settle, Maturity)
%
%   NextCouponDate = cpndaten(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
% ����: 
%     Settle    - ���ϓ�
%     Maturity  - ������
%
% �I�v�V�����̓���:
%     Period - �N������̃N�[�|���x����; �f�t�H���g�� 2 (���N����)
%     Basis - ���t�J�E���g�; �f�t�H���g�� 0 (actual/actual)
%     EndMonthRule - �����K��; �f�t�H���g�� 1 (�����K���͗L��)
%     IssueDate - ���̔��s��
%     FirstCouponDate - �ŏ��̃N�[�|���x����
%     LastCouponDate - �Ō�̃N�[�|���x����
%
% �o��: 
%     NextCouponDate - ���ϓ��ȍ~�̎��ۂ̎���N�[�|�����̓��t����Ȃ�
%       NUMBONDS�s1�� �̃x�N�g���ł��B���ϓ����N�[�|�����Ɠ���̏ꍇ�A
%       ���̊֐��͌��ϓ����o�͂��܂���B���̑���ɁA�����Ɍ��ϓ��ȍ~��
%       ���ۂ̃N�[�|�������o�͂��܂� (�������A�������ȍ~�̏ꍇ������)�B
%       ���̂��߁A���̊֐��͏�Ɏ��ۂ̖������Ǝ���N�[�|���x�����̂����A
%       ���߂��ق��̓��t����ɏo�͂��܂��B
%
% ����:
%     �K�{�̈����́A NUMBONDS�s1��A�܂���1�sNUMBONDS��̃x�N�g���A�܂���
%     �X�J�������łȂ���΂Ȃ�܂���B�I�v�V�����̈����́ANUMBONDS�s1��A
%     �܂��́A1�sNUMBONDS ��̃x�N�g���A�X�J���A�܂��͋�s��łȂ���΂Ȃ�
%     �܂���B�l�̎w��̂Ȃ����͂ɂ� NaN ����̓x�N�g���Ƃ��Đݒ肵��
%     ���������B���t�́A�V���A�����t�ԍ��A�܂��͓��t������ł��B
%
%     ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%     'help ftb' + ������ (���Ƃ��΁ASettle(���ϓ�)�Ɋւ���w���v�́A
%     "help ftbSettle"�j�ƃ^�C�v���ĎQ�Ƃł��܂��B
%
% �Q�l CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%      CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.

% Copyright 1995-2006 The MathWorks, Inc.
