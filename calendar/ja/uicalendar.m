%UICALENDAR  �O���t�B�J���ȃJ�����_
%
%   UICALENDAR �́Auicontrol �Ƃ̃C���^�t�F�[�X���������J�X�^�}�C�Y�\��
%   �O���t�B�J���ȃJ�����_�ł��BUICALENDAR �́A���[�U���I���������t�� 
%   uicontrol ���쐬���܂��B
%
%   uicalendar('PARAM1', VALUE1, 'PARAM2', VALUE2', ...)
%
%   ����:
%   �p�����[�^        - �l            : ����
%   ---------------------------------------------------------------------------
%   'BusDays'          - 0            : (�f�t�H���g) ��c�Ɠ��̎w�W�������Ȃ�
%                                       �W���̃J�����_�ł��B
%
%                        1            : NYSE �̔�c�Ɠ���Ԃň��t����B
%
%   'BusDaySelect'     - 0            : �c�Ɠ��̑I���݂̂������܂��B
%                                       ��c�Ɠ��͈ȉ��̃p�����[�^�����`
%                                       ����܂��B
%
%                                       'BusDays'
%                                       'Holiday'
%                                       'Weekend'
%
%                        1            : (�f�t�H���g) �c�Ɠ��Ɣ�c�Ɠ��̑I����
%                                       �����܂��B
%
%   'DateBoxColor'     - [���t R G B] : ���t�̘g���̐F���w�肵�� [R G B] ��
%                                       �F�ɐݒ肵�܂��B
%
%   'DateStrColor'     - [���t R G B] : ���t�̐F���w�肵�� [R G B] �̐F�ɐݒ肵�܂��B
%
%   'DestinationUI'    - H            : �w�肷��I�u�W�F�N�g�̃n���h���̃X�J��
%                                       �܂��̓x�N�g���ł��B���t����Ȃ�f�t�H���g�� 
%                                       UI �� 'string' �ł��B
%
%                        {H, {Prop}}  : �n���h���Ǝw�肷��I�u�W�F�N�g�� UI 
%                                       �v���p�e�B�̃Z���z��ł��BH �̓X�J����
%                                       �x�N�g���łȂ���΂Ȃ�܂���B�܂��A
%                                       'Prop' �͒P��̃v���p�e�B�̕�����A
%                                       �܂��́A�v���p�e�B�̕�����̃Z���z��
%                                       �łȂ���΂Ȃ�܂���B
%
%   'Holiday'          - Dates        : �w�肵���x�����J�����_�ɐݒ肵�܂��B
%                                       �x���ɑΉ�������t������͐Ԃŕ\����܂��B
%                                       Date �́Adatenum �̃X�J���܂��̓x�N�g��
%                                       �łȂ���΂Ȃ�܂���B
%
%   'InitDate'         - Datenum      : �J�����_������������ꍇ�̏����̊J�n��
%                                       ���w�肷�鐔�l�̓��t�̒l�ł��B
%                                       �f�t�H���g�l�͍����ł��B
%
%                        Datestr      : �J�����_������������ꍇ�̏����̊J�n��
%                                       ���w�肷����t������̒l�ł��BDatestr �́A
%                                       Year, Month, Day ���܂܂Ȃ���΂Ȃ�܂��� 
%                                       (��. 01-Jan-2006)�B
%
%   'InputDateFormat'  - Format       : �����̊J�n�� InitDate �̌`����ݒ肵�܂��B
%                                       ���t�̌`���̒l�ɂ��ẮA'help datestr' 
%                                       ���Q�Ƃ��Ă��������B
%
%   'OutputDateFormat' - Format       : �o�͂̓��t������̌`����ݒ肵�܂��B
%                                       ���t�̌`���̒l�ɂ��ẮA'help datestr' 
%                                       ���Q�Ƃ��Ă��������B
%
%   'OutputDateStyle'  - 0            : (�f�t�H���g) �P��̓��t������A�܂��́A
%                                       ���t������̃Z���z�� (�s) ��Ԃ��܂��B
%                                       ��. {'01-Jan-2001, 02-Jan-2001, ...'}
%
%                        1            : �P��̓��t������A�܂��́A���t������
%                                       �̃Z���z�� (��) ��Ԃ��܂��B
%                                       ��. {'01-Jan-2001; 02-Jan-2001; ...'}
%
%                        2            : datenum �̃x�N�g���̍s�x�N�g���̕�����
%                                       �\����Ԃ��܂��B
%                                       ��. '[732758, 732759, 732760, 732761]'
%
%                        3            : datenum �̃x�N�g���̗�x�N�g���̕�����
%                                       �\����Ԃ��܂��B
%                                       ��. '[732758; 732759; 732760; 732761]'
%
%   'SelectionType'    - 0            : �����̓��t�̑I���������܂��B
%
%                        1            : (�f�t�H���g) �P��̓��t�I���݂̂�����
%                                       ���܂��B
%
%   'Weekend'          - DayOfWeek    : �T�̎w�肵�������T���Ƃ��Đݒ肵�܂��B
%                                       �T���͐Ԃň󂪕t�����܂��B
%
%                                       DayOfWeek �́A�ȉ��̐��l���܂ރx�N�g��
%                                       �ɂȂ�܂��B
%
%                                       1 - ���j
%                                       2 - ���j
%                                       3 - �Ηj
%                                       4 - ���j
%                                       5 - �ؗj
%                                       6 - ���j
%                                       7 - �y�j
%
%                                       ���邢�́A0 �� 1 ���܂ޒ��� 7 ��
%                                       �x�N�g���ɂȂ�܂��B�l 1 �́A�T���������܂��B
%                                       ���̃x�N�g���̍ŏ��̗v�f�́ASunday ��
%                                       �Ή����܂��B
%
%                                       ���Ƃ��΁ASaturday �� Sunday ���T���Ƃ���ƁA
%                                       WEEKEND = [1 0 0 0 0 0 1] �ƂȂ�܂��B
%
%   'WindowStyle'      - Normal       : (�f�t�H���g) �W���� Figure �̃v���p�e�B�ł��B
%
%                        Modal        : Modal �� Figure �́A��L�̂��ׂẴm�[�}���� 
%                                       Figure �� MATLAB �R�}���h�E�B���h�E���d�˂܂��B
%
%   ��:
%      uicontrol �̍쐬:
%      textH1 = uicontrol('style', 'edit', 'position', [10 10 100 20]);
%
%      UICALENDAR �̌Ăяo��:
%      uicalendar('DestinationUI', {textH1, 'string'})
%
%      ���t��I������ 'OK' �������܂��B


% Copyright 1995-2008 The MathWorks, Inc.
